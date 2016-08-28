#include <Windows.h>
#include <tchar.h>
#include "VulkanTest.h"


HINSTANCE hinst;
HWND hwndMain;
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
VulkanTest test;

int CALLBACK WinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPSTR lpCmdLine, _In_ int nShowCmd)
{
	MSG msg;
	WNDCLASS wc;

	if (!hPrevInstance)
	{
		wc.style = 0;
		wc.lpfnWndProc = (WNDPROC)WndProc;
		wc.cbClsExtra = 0;
		wc.cbWndExtra = 0;
		wc.hInstance = hInstance;
		wc.hIcon = LoadIcon((HINSTANCE)NULL,
			IDI_APPLICATION);
		wc.hCursor = LoadCursor((HINSTANCE)NULL,
			IDC_ARROW);
		wc.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
		wc.lpszMenuName = _T("MainMenu");
		wc.lpszClassName = _T("MainWndClass");

		if (!RegisterClass(&wc))
			return FALSE;
	}

	hinst = hInstance;
	hwndMain = CreateWindow(_T("MainWndClass"), _T("Sample"), WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT,
		CW_USEDEFAULT, CW_USEDEFAULT, (HWND)NULL, (HMENU)NULL, hinst, (LPVOID)NULL);
	if (!hwndMain)
		return FALSE;
	ShowWindow(hwndMain, nShowCmd);
	UpdateWindow(hwndMain);

	test.init();

	while (TRUE)
	{
		if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
		{
			if (msg.message == WM_QUIT)
				break;
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		test.render();
	}

	test.shutdown();

	return 0;
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT iMsg, WPARAM wParam, LPARAM lParam)
{
	switch (iMsg)
	{
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;
	default:
		break;
	}
	return DefWindowProc(hWnd, iMsg, wParam, lParam);
}