#include "VulkanTest.h"



VulkanTest::VulkanTest()
	: m_Instance(nullptr)
{
}

VulkanTest::~VulkanTest()
{
}

bool VulkanTest::init()
{
	ApplicationInfo appInfo;
	appInfo.pApplicationName = "VulkanTest";
	appInfo.pEngineName = "VulkanTest";
	appInfo.apiVersion = VK_API_VERSION_1_0;

	std::vector<char const *> enabledExtensions = { VK_KHR_SURFACE_EXTENSION_NAME };
	enabledExtensions.push_back(VK_KHR_WIN32_SURFACE_EXTENSION_NAME);

	//enabledExtensions.push_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);

	vk::InstanceCreateInfo instanceCreateInfo;
	instanceCreateInfo.pApplicationInfo = &appInfo;

	if (enabledExtensions.size() > 0)
	{
		instanceCreateInfo.enabledExtensionCount = (uint32_t)enabledExtensions.size();
		instanceCreateInfo.ppEnabledExtensionNames = enabledExtensions.data();
	}
	//instanceCreateInfo.enabledLayerCount = vkDebug::validationLayerNames.size();
	//instanceCreateInfo.ppEnabledLayerNames = vkDebug::validationLayerNames.data();
	m_Instance = vk::createInstance(instanceCreateInfo);

	physicalDevices = m_Instance.enumeratePhysicalDevices();
	physicalDevice = physicalDevices[0];
	struct Version {
		uint32_t patch : 12;
		uint32_t minor : 10;
		uint32_t major : 10;
	} _version;
	// Store properties (including limits) and features of the phyiscal device
	// So examples can check against them and see if a feature is actually supported
	deviceProperties = physicalDevice.getProperties();
	memcpy(&_version, &deviceProperties.apiVersion, sizeof(uint32_t));
	deviceFeatures = physicalDevice.getFeatures();
	// Gather physical device memory properties
	deviceMemoryProperties = physicalDevice.getMemoryProperties();

	// Vulkan device
	{
		// Find a queue that supports graphics operations
		uint32_t graphicsQueueIndex = findQueue(vk::QueueFlagBits::eGraphics);
		std::array<float, 1> queuePriorities = { 0.0f };
		vk::DeviceQueueCreateInfo queueCreateInfo;
		queueCreateInfo.queueFamilyIndex = graphicsQueueIndex;
		queueCreateInfo.queueCount = 1;
		queueCreateInfo.pQueuePriorities = queuePriorities.data();
		std::vector<const char*> enabledExtensions = { VK_KHR_SWAPCHAIN_EXTENSION_NAME };
		vk::DeviceCreateInfo deviceCreateInfo;
		deviceCreateInfo.queueCreateInfoCount = 1;
		deviceCreateInfo.pQueueCreateInfos = &queueCreateInfo;
		deviceCreateInfo.pEnabledFeatures = &deviceFeatures;
		// enable the debug marker extension if it is present (likely meaning a debugging tool is present)
		//if (vkx::checkDeviceExtensionPresent(physicalDevice, VK_EXT_DEBUG_MARKER_EXTENSION_NAME)) {
		//	enabledExtensions.push_back(VK_EXT_DEBUG_MARKER_EXTENSION_NAME);
		//	enableDebugMarkers = true;
		//}
		if (enabledExtensions.size() > 0) {
			deviceCreateInfo.enabledExtensionCount = (uint32_t)enabledExtensions.size();
			deviceCreateInfo.ppEnabledExtensionNames = enabledExtensions.data();
		}
		//if (enableValidation) {
		//	deviceCreateInfo.enabledLayerCount = (uint32_t)debug::validationLayerNames.size();
		//	deviceCreateInfo.ppEnabledLayerNames = debug::validationLayerNames.data();
		//}
		device = physicalDevice.createDevice(deviceCreateInfo);
	}

	pipelineCache = device.createPipelineCache(vk::PipelineCacheCreateInfo());
	// Find a queue that supports graphics operations
	graphicsQueueIndex = findQueue(vk::QueueFlagBits::eGraphics);
	// Get the graphics queue
	queue = device.getQueue(graphicsQueueIndex, 0);

	return true;
}

void VulkanTest::shutdown()
{
	queue.waitIdle();
	device.waitIdle();

	device.destroyPipelineCache(pipelineCache);
	device.destroy();
	
	//debug::freeDebugCallback(instance);
	
	m_Instance.destroy();
}

void VulkanTest::render()
{

}

void VulkanTest::update(float deltaTime)
{
}

uint32_t VulkanTest::findQueue(const vk::QueueFlags& flags, const vk::SurfaceKHR& presentSurface) const {
	std::vector<vk::QueueFamilyProperties> queueProps = physicalDevice.getQueueFamilyProperties();
	size_t queueCount = queueProps.size();
	for (uint32_t i = 0; i < queueCount; i++) {
		if (queueProps[i].queueFlags & flags) {
			if (presentSurface && !physicalDevice.getSurfaceSupportKHR(i, presentSurface)) {
				continue;
			}
			return i;
		}
	}
	throw std::runtime_error("No queue matches the flags " + vk::to_string(flags));
}