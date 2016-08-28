#ifndef __Vulkan_H__
#define __Vulkan_H__
#pragma once
#include <vulkan.hpp>

using namespace vk;

class VulkanTest
{
public:
	VulkanTest();
	~VulkanTest();

	bool init();
	void shutdown();
	void render();
	void update(float deltaTime);
private:
	uint32_t findQueue(const vk::QueueFlags& flags, const vk::SurfaceKHR& presentSurface = vk::SurfaceKHR()) const;
private:
	// Vulkan instance, stores all per-application states
	vk::Instance m_Instance;
	std::vector<vk::PhysicalDevice> physicalDevices;
	// Physical device (GPU) that Vulkan will ise
	vk::PhysicalDevice physicalDevice;
	// Stores physical device properties (for e.g. checking device limits)
	vk::PhysicalDeviceProperties deviceProperties;
	// Stores phyiscal device features (for e.g. checking if a feature is available)
	vk::PhysicalDeviceFeatures deviceFeatures;
	// Stores all available memory (type) properties for the physical device
	vk::PhysicalDeviceMemoryProperties deviceMemoryProperties;
	// Logical device, application's view of the physical device (GPU)
	vk::Device device;
	// vk::Pipeline cache object
	vk::PipelineCache pipelineCache;
	// List of shader modules created (stored for cleanup)
	mutable std::vector<vk::ShaderModule> shaderModules;

	vk::Queue queue;
	// Find a queue that supports graphics operations
	uint32_t graphicsQueueIndex;
};

#endif