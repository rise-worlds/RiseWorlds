#include "pch.h"
#include "MyMetroApp.h"
#include <wrl.h>
#include <wrl/client.h>
#include <ppl.h>
#include <ppltasks.h>

using namespace Windows::ApplicationModel;
using namespace Windows::ApplicationModel::Core;
using namespace Windows::ApplicationModel::Activation;
using namespace Windows::UI::Core;
using namespace Windows::System;
using namespace Windows::Foundation;
using namespace Windows::Graphics::Display;
using namespace Windows::Storage;
using namespace Concurrency;

Direct3DApp1::Direct3DApp1() :
	m_windowClosed(false),
	m_windowVisible(true)
{
}
// 添加App基础事件
void Direct3DApp1::Initialize(CoreApplicationView^ applicationView)
{
	applicationView->Activated +=
        ref new TypedEventHandler<CoreApplicationView^, IActivatedEventArgs^>(this, &Direct3DApp1::OnActivated);
	// 挂起时
	CoreApplication::Suspending +=
        ref new EventHandler<SuspendingEventArgs^>(this, &Direct3DApp1::OnSuspending);
	// 从挂起中恢复时
	CoreApplication::Resuming +=
        ref new EventHandler<Platform::Object^>(this, &Direct3DApp1::OnResuming);
}
// 添加窗口基础事件
void Direct3DApp1::SetWindow(CoreWindow^ window)
{
	window->SizeChanged += 
        ref new TypedEventHandler<CoreWindow^, WindowSizeChangedEventArgs^>(this, &Direct3DApp1::OnWindowSizeChanged);

	window->VisibilityChanged +=
		ref new TypedEventHandler<CoreWindow^, VisibilityChangedEventArgs^>(this, &Direct3DApp1::OnVisibilityChanged);

	window->Closed += 
        ref new TypedEventHandler<CoreWindow^, CoreWindowEventArgs^>(this, &Direct3DApp1::OnWindowClosed);

	window->PointerCursor = ref new CoreCursor(CoreCursorType::Arrow, 0);

	window->PointerPressed +=
		ref new TypedEventHandler<CoreWindow^, PointerEventArgs^>(this, &Direct3DApp1::OnPointerPressed);

	window->PointerMoved +=
		ref new TypedEventHandler<CoreWindow^, PointerEventArgs^>(this, &Direct3DApp1::OnPointerMoved);
}

void Direct3DApp1::Load(Platform::String^ entryPoint)
{
}
// 主循环
void Direct3DApp1::Run()
{
	while (!m_windowClosed)
	{
		if (m_windowVisible)
		{
			CoreWindow::GetForCurrentThread()->Dispatcher->ProcessEvents(CoreProcessEventsOption::ProcessAllIfPresent);
		}
		else
		{
			CoreWindow::GetForCurrentThread()->Dispatcher->ProcessEvents(CoreProcessEventsOption::ProcessOneAndAllPending);
		}
	}
}

void Direct3DApp1::Uninitialize()
{
}

void Direct3DApp1::OnWindowSizeChanged(CoreWindow^ sender, WindowSizeChangedEventArgs^ args)
{
}

void Direct3DApp1::OnVisibilityChanged(CoreWindow^ sender, VisibilityChangedEventArgs^ args)
{
	m_windowVisible = args->Visible;
}

void Direct3DApp1::OnWindowClosed(CoreWindow^ sender, CoreWindowEventArgs^ args)
{
	m_windowClosed = true;
}

void Direct3DApp1::OnPointerPressed(CoreWindow^ sender, PointerEventArgs^ args)
{
	// 在此处插入代码。
}

void Direct3DApp1::OnPointerMoved(CoreWindow^ sender, PointerEventArgs^ args)
{
	// 在此处插入代码。
}

void Direct3DApp1::OnActivated(CoreApplicationView^ applicationView, IActivatedEventArgs^ args)
{
	CoreWindow::GetForCurrentThread()->Activate();
}

void Direct3DApp1::OnSuspending(Platform::Object^ sender, SuspendingEventArgs^ args)
{
	// 在请求延期后异步保存应用程序状态。保留延期
	// 表示应用程序正忙于执行挂起操作。
	// 请注意，延期不是无限期的。在大约五秒后，
	// 将强制应用程序退出。
	SuspendingDeferral^ deferral = args->SuspendingOperation->GetDeferral();

	create_task([this, deferral]()
	{
		// 在此处插入代码。

		deferral->Complete();
	});
}
 
void Direct3DApp1::OnResuming(Platform::Object^ sender, Platform::Object^ args)
{
	// 还原在挂起时卸载的任何数据或状态。默认情况下，
	// 在从挂起中恢复时，数据和状态会持续保留。请注意，
	// 如果之前已终止应用程序，则不会发生此事件。
}

IFrameworkView^ Direct3DApplicationSource::CreateView()
{
    return ref new Direct3DApp1();
}

[Platform::MTAThread]
int main(Platform::Array<Platform::String^>^)
{
	auto direct3DApplicationSource = ref new Direct3DApplicationSource();
	CoreApplication::Run(direct3DApplicationSource);
	return 0;
}
