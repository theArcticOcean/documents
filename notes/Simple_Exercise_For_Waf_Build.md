Let's describe a 3D parametric curve by the form.
$$ x = \cos{t} \\
y = \sin{t} \\
z = t*s
$$
The value s is in [0, 1]. It is a circle when s is zero, in the other situations it represents a spiral.

```cpp
#include <vtkPointData.h>
#include <vtkSmartPointer.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkRenderer.h>
#include <vtkPolyData.h>
#include <vtkProperty.h>
#include <vtkSphereSource.h>
#include <vtkPolyDataMapper.h>
#include <vtkCommand.h>
#include <vtkSliderWidget.h>
#include <vtkSliderRepresentation.h>
#include <vtkTransform.h>
#include <vtkSliderRepresentation3D.h>
#include <vtkWidgetEventTranslator.h>
#include <vtkWidgetEvent.h>

#include "./tool.h"

#define vtkSPtr vtkSmartPointer
#define vtkSPtrNew(Var, Type) vtkSPtr<Type> Var = vtkSPtr<Type>::New();

void ScalePointsZValue( vtkSPtr<vtkPolyData> data, double factor )
{
    vtkSPtrNew( points, vtkPoints );
    vtkSPtrNew( lines, vtkCellArray );
    for( int i = 0; i < 360*3; ++i )
    {
        auto t = vtkMath::RadiansFromDegrees( double(i) );
        PointStruct pt( cos( t ), sin( t ), factor*t );
        points->InsertNextPoint( pt.point );
    }
    for( int i = 0; i < points->GetNumberOfPoints(); ++i )
    {
        vtkIdType ids[2] = { i, (i+1)%points->GetNumberOfPoints() };
        lines->InsertNextCell( 2, ids );
    }
    data->SetPoints( points );
    data->SetLines( lines );
}

class vtkSliderCallback : public vtkCommand
{
public:
    static vtkSliderCallback *New()
    { return new vtkSliderCallback; }
    void Execute(vtkObject *caller, unsigned long, void*) override
    {
        vtkSliderWidget *sliderWidget =
          reinterpret_cast<vtkSliderWidget*>(caller);
        double scaleValue = static_cast<vtkSliderRepresentation *>(sliderWidget->GetRepresentation())->GetValue();
        cout << "scaleValue: " << scaleValue << endl;
        ScalePointsZValue( m_Data, scaleValue );
    }
    vtkSliderCallback():m_Data(nullptr) {}
    vtkSPtr<vtkPolyData> m_Data;
};

int main(int, char *[])
{
    vtkSPtrNew( data, vtkPolyData );
    ScalePointsZValue( data, 0 );

    vtkSPtrNew( mapper, vtkPolyDataMapper );
    mapper->SetInputData( data );

    vtkSPtrNew( actor, vtkActor );
    actor->SetMapper( mapper );

    vtkSPtrNew( renderer, vtkRenderer );
    renderer->AddActor(actor);
    renderer->SetBackground( 0, 0, 0 );

    vtkSPtrNew( renderWindow, vtkRenderWindow );
    renderWindow->AddRenderer( renderer );

    vtkSPtrNew( renderWindowInteractor, vtkRenderWindowInteractor );
    renderWindowInteractor->SetRenderWindow( renderWindow );

    vtkSmartPointer<vtkSliderRepresentation3D> sliderRep =
        vtkSmartPointer<vtkSliderRepresentation3D>::New();
    sliderRep->SetValue( 0.2 );
    sliderRep->GetPoint1Coordinate()->SetCoordinateSystemToWorld();
    sliderRep->GetPoint1Coordinate()->SetValue(0,0,0);
    sliderRep->GetPoint2Coordinate()->SetCoordinateSystemToWorld();
    sliderRep->GetPoint2Coordinate()->SetValue(2,0,0);
    sliderRep->SetSliderLength(0.075);
    sliderRep->SetSliderWidth(0.05);
    sliderRep->SetEndCapLength(0.05);

    vtkSmartPointer<vtkSliderWidget> sliderWidget =
        vtkSmartPointer<vtkSliderWidget>::New();
    sliderWidget->GetEventTranslator()->SetTranslation(vtkCommand::RightButtonPressEvent,
                                                       vtkWidgetEvent::Select);
    sliderWidget->GetEventTranslator()->SetTranslation(vtkCommand::RightButtonReleaseEvent,
                                                       vtkWidgetEvent::EndSelect);

    vtkSmartPointer<vtkSliderCallback> callback =
      vtkSmartPointer<vtkSliderCallback>::New();
    callback->m_Data = data;
    sliderWidget->AddObserver(vtkCommand::InteractionEvent,callback);

    sliderWidget->SetInteractor( renderWindowInteractor );
    sliderWidget->SetRepresentation( sliderRep );
    sliderWidget->SetAnimationModeToAnimate();
    sliderWidget->EnabledOn();

    renderer->ResetCamera();
    renderWindow->Render();
    renderWindowInteractor->Start();

    return EXIT_SUCCESS;
}
```
