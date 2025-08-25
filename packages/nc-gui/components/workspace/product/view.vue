<script lang="ts" setup>
import { useTitle } from '@vueuse/core'

// Utility function to safely format price
const formatPrice = (price: unknown): string => {
  if (price === null || price === undefined) return '0.00'
  const numPrice = typeof price === 'string' ? Number.parseFloat(price) : Number(price)
  return Number.isNaN(numPrice) ? '0.00' : numPrice.toFixed(2)
}

const { isUIAllowed } = useRoles()

const { hideSidebar, isNewSidebarEnabled } = storeToRefs(useSidebarStore())

const workspaceStore = useWorkspace()

const { loadRoles } = useRoles()
const { activeWorkspace: _activeWorkspace } = storeToRefs(workspaceStore)
const { loadCollaborators } = workspaceStore

const currentWorkspace = computedAsync(async () => {
  await loadRoles(undefined, {}, _activeWorkspace.value?.id)
  return _activeWorkspace.value
})

// Mock data for the product matching interface
const matchingProducts = ref([
  {
    id: 1,
    name: 'UPPAbaby VISTA V2 Stroller',
    percentage: 95,
    price: 969.99,
    status: 'orange',
    image: '/api/placeholder/60/60',
    brand: 'UPPAbaby',
    category: 'Strollers',
    source: 'Catalog',
    selected: false
  },
  {
    id: 2,
    name: 'Bugaboo Fox 3 Stroller',
    percentage: 88,
    price: 1299.00,
    status: 'green',
    image: '/api/placeholder/60/60',
    brand: 'Bugaboo',
    category: 'Strollers',
    source: 'Catalog',
    selected: true
  },
  {
    id: 3,
    name: 'Nuna MIXX Next Stroller',
    percentage: 92,
    price: 649.95,
    status: 'orange',
    image: '/api/placeholder/60/60',
    brand: 'Nuna',
    category: 'Strollers',
    source: 'Catalog',
    selected: false
  },
  {
    id: 4,
    name: 'Cybex Gazelle S Stroller',
    percentage: 78,
    price: 849.95,
    status: 'green',
    image: '/api/placeholder/60/60',
    brand: 'Cybex',
    category: 'Strollers',
    source: 'Catalog',
    selected: true
  },
  {
    id: 5,
    name: 'Thule Spring Stroller',
    percentage: 85,
    price: 399.95,
    status: 'orange',
    image: '/api/placeholder/60/60',
    brand: 'Thule',
    category: 'Strollers',
    source: 'Catalog',
    selected: false
  }
])

const selectionOptions = ref([
  {
    id: 1,
    leftProduct: {
      name: 'Graco Modes Pramette Stroller',
      color: 'Blue',
      sku: '8717447138327',
      price: 299.99,
      image: '/api/placeholder/120/120'
    },
    rightProduct: {
      name: 'Cybex Gazelle S Stroller',
      color: 'Blue',
      sku: '8717447138327',
      price: 299.99,
      image: '/api/placeholder/120/120'
    },
    selected: false
  },
  {
    id: 2,
    leftProduct: {
      name: 'Chicco Bravo Trio Travel System',
      color: 'Black',
      sku: '4058511661445',
      price: 399.99,
      image: '/api/placeholder/120/120'
    },
    rightProduct: {
      name: 'Cybex Gazelle S Stroller',
      color: 'Black',
      sku: '4058511661445',
      price: 399.99,
      image: '/api/placeholder/120/120'
    },
    selected: false
  },
  {
    id: 3,
    leftProduct: {
      name: 'Evenflo Pivot Xpand Modular Travel System',
      color: 'Gray',
      sku: '817609018467',
      price: 369.99,
      image: '/api/placeholder/120/120'
    },
    rightProduct: {
      name: 'Cybex Gazelle S Stroller',
      color: 'Gray',
      sku: '817609018467',
      price: 369.99,
      image: '/api/placeholder/120/120'
    },
    selected: true
  }
])

const filters = ref({
  brand: '',
  category: '',
  source: '',
  status: '',
  orderBy: 'percentage',
  search: ''
})

const toggleProductSelection = (productId: number) => {
  const product = matchingProducts.value.find(p => p.id === productId)
  if (product) {
    product.selected = !product.selected
  }
}

const toggleOptionSelection = (optionId: number) => {
  // Deselect all other options
  selectionOptions.value.forEach(option => {
    option.selected = option.id === optionId
  })
}

watch(
  () => currentWorkspace.value?.title,
  (title) => {
    if (!title) return

    const capitalizedTitle = title.charAt(0).toUpperCase() + title.slice(1)

    useTitle(capitalizedTitle)
  },
  {
    immediate: true,
  },
)

onMounted(() => {
  if (isNewSidebarEnabled.value) {
    hideSidebar.value = true
  }

  until(() => currentWorkspace.value?.id)
    .toMatch((v) => !!v)
    .then(async () => {
      await loadCollaborators({ includeDeleted: true }, currentWorkspace.value!.id)
    })
})

onBeforeMount(() => {
  hideSidebar.value = false
})
</script>

<template>
  <div v-if="currentWorkspace" class="flex w-full flex-col nc-workspace-product">
    <div class="flex gap-2 items-center min-w-0 p-2 h-[var(--topbar-height)] border-b-1 border-gray-200">
      <GeneralOpenLeftSidebarBtn v-if="!isNewSidebarEnabled" />

      <div class="flex-1 nc-breadcrumb nc-no-negative-margin pl-1">
        <div class="nc-breadcrumb-item capitalize">
          {{ currentWorkspace?.title }}
        </div>
        <GeneralIcon icon="ncSlash1" class="nc-breadcrumb-divider" />
        <h1 class="nc-breadcrumb-item active">
          {{ $t('general.product') }}
        </h1>
      </div>

      <SmartsheetTopbarCmdK v-if="!isNewSidebarEnabled" />
    </div>
    
    <div class="flex-1 flex">
      <!-- Left Panel: Matching Products -->
      <div class="w-1/2 border-r border-gray-200 bg-gray-50">
        <div class="p-4 border-b border-gray-200">
          <h2 class="text-lg font-semibold text-gray-900 mb-4">
            Matching Products ({{ matchingProducts.length }})
          </h2>
          
          <!-- Filters -->
          <div class="grid grid-cols-2 gap-3 mb-4">
            <NcSelect v-model:value="filters.brand" placeholder="Brand" size="small">
              <NcSelectOption value="">All Brands</NcSelectOption>
              <NcSelectOption value="UPPAbaby">UPPAbaby</NcSelectOption>
              <NcSelectOption value="Bugaboo">Bugaboo</NcSelectOption>
              <NcSelectOption value="Nuna">Nuna</NcSelectOption>
              <NcSelectOption value="Cybex">Cybex</NcSelectOption>
              <NcSelectOption value="Thule">Thule</NcSelectOption>
            </NcSelect>
            
            <NcSelect v-model:value="filters.category" placeholder="Category" size="small">
              <NcSelectOption value="">All Categories</NcSelectOption>
              <NcSelectOption value="Strollers">Strollers</NcSelectOption>
              <NcSelectOption value="Car Seats">Car Seats</NcSelectOption>
              <NcSelectOption value="Travel Systems">Travel Systems</NcSelectOption>
            </NcSelect>
            
            <NcSelect v-model:value="filters.source" placeholder="Source" size="small">
              <NcSelectOption value="">All Sources</NcSelectOption>
              <NcSelectOption value="Catalog">Catalog</NcSelectOption>
              <NcSelectOption value="Import">Import</NcSelectOption>
            </NcSelect>
            
            <NcSelect v-model:value="filters.status" placeholder="Status" size="small">
              <NcSelectOption value="">All Status</NcSelectOption>
              <NcSelectOption value="green">Active</NcSelectOption>
              <NcSelectOption value="orange">Pending</NcSelectOption>
            </NcSelect>
          </div>
          
          <div class="flex gap-2 mb-4">
            <NcSelect v-model:value="filters.orderBy" placeholder="Order by" size="small" class="w-32">
              <NcSelectOption value="percentage">Match %</NcSelectOption>
              <NcSelectOption value="price">Price</NcSelectOption>
              <NcSelectOption value="name">Name</NcSelectOption>
            </NcSelect>
            
            <NcInput 
              v-model:value="filters.search" 
              placeholder="Search products..." 
              size="small"
              class="flex-1"
            >
              <template #prefix>
                <GeneralIcon icon="search" class="h-4 w-4 text-gray-400" />
              </template>
            </NcInput>
          </div>
        </div>
        
        <!-- Product List -->
        <div class="p-4 space-y-2 max-h-[calc(100vh-200px)] overflow-y-auto">
          <div
            v-for="product in matchingProducts"
            :key="product.id"
            @click="toggleProductSelection(product.id)"
            :class="[
              'p-3 rounded-lg cursor-pointer hover:bg-gray-100 transition-colors border',
              product.selected ? 'bg-green-50 border-green-200' : 'bg-white border-gray-200'
            ]"
          >
            <div class="flex items-center gap-3">
                             <img 
                 :src="product.image || 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=48&h=48&fit=crop&crop=center'" 
                 :alt="product.name"
                 class="w-12 h-12 rounded object-cover bg-gray-200"
                 @error="$event.target.src = 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=48&h=48&fit=crop&crop=center'"
               />
              
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2 mb-1">
                  <h3 class="text-sm font-medium text-gray-900 truncate">
                    {{ product.name }}
                  </h3>
                  <div 
                    :class="[
                      'w-2 h-2 rounded-full',
                      product.status === 'green' ? 'bg-green-500' : 'bg-orange-500'
                    ]"
                  ></div>
                </div>
                
                <div class="flex items-center justify-between">
                  <span class="text-sm text-gray-600">{{ product.percentage }}%</span>
                  <span class="text-sm font-medium text-gray-900">${{ formatPrice(product.price) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Right Panel: Selection Options -->
      <div class="w-1/2 bg-white">
        <div class="p-4 border-b border-gray-200">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-gray-900">
              Select one option ({{ selectionOptions.length }})
            </h2>
            <NcButton type="text" size="small">
              No Option
            </NcButton>
          </div>
        </div>
        
        <div class="p-4 space-y-6 max-h-[calc(100vh-200px)] overflow-y-auto">
          <div
            v-for="option in selectionOptions"
            :key="option.id"
            @click="toggleOptionSelection(option.id)"
            :class="[
              'p-4 rounded-lg cursor-pointer hover:bg-gray-50 transition-colors border',
              option.selected ? 'bg-green-50 border-green-200' : 'bg-white border-gray-200'
            ]"
          >
                         <!-- Single Row Layout: [Image 1] [Image 2] [Details 1] [Details 2] -->
             <div class="flex items-center gap-6">
               <!-- Image 1 -->
               <img 
                 :src="option.leftProduct.image || 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=120&h=120&fit=crop&crop=center'" 
                 :alt="option.leftProduct.name"
                 class="w-24 h-24 rounded-lg object-cover bg-gray-200 border border-gray-300 flex-shrink-0"
                 @error="$event.target.src = 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=120&h=120&fit=crop&crop=center'"
               />
               
               <!-- Image 2 -->
               <img 
                 :src="option.rightProduct.image || 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=120&h=120&fit=crop&crop=center'" 
                 :alt="option.rightProduct.name"
                 class="w-24 h-24 rounded-lg object-cover bg-gray-200 border border-gray-300 flex-shrink-0"
                 @error="$event.target.src = 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=120&h=120&fit=crop&crop=center'"
               />
               
                               <!-- Details 1 - Right Aligned -->
                <div class="flex-1 min-w-0">
                  <div class="space-y-1 text-right">
                    <div class="font-semibold text-gray-900 text-sm leading-tight truncate">{{ option.leftProduct.name }}</div>
                    <div class="text-xs text-gray-600">{{ option.leftProduct.color }}</div>
                    <div class="text-xs text-gray-500 font-mono">{{ option.leftProduct.sku }}</div>
                    <div class="font-bold text-gray-900 text-base">${{ formatPrice(option.leftProduct.price) }}</div>
                  </div>
                </div>
                
                <!-- Details 2 - Left Aligned -->
                <div class="flex-1 min-w-0">
                  <div class="space-y-1 text-left">
                    <div class="font-semibold text-gray-900 text-sm leading-tight truncate">{{ option.rightProduct.name }}</div>
                    <div class="text-xs text-gray-600">{{ option.rightProduct.color }}</div>
                    <div class="text-xs text-gray-500 font-mono">{{ option.rightProduct.sku }}</div>
                    <div class="font-bold text-gray-900 text-base">${{ formatPrice(option.rightProduct.price) }}</div>
                  </div>
                </div>
             </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.nc-workspace-product {
  @apply h-full;
}
</style>
