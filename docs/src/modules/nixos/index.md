# NixOS Module

<div v-if="!!data">
  <div v-for="(value, key, _) in data" :key="key">
    <h2>{{ key.replace(/[^.]+\./,'') }}</h2>
    <div :class="$style['option-meta-container']">
      <div :class="$style['option-meta-name']">Name</div>
      <div :class="$style['option-meta-value']">
        <button @click="copyCode"><code>{{key}}</code></button>
      </div>
      <div :class="$style['option-meta-name']">Description</div>
      <div :class="$style['option-meta-value']">
        {{value.description}}
      </div>
      <div :class="$style['option-meta-name']">Type</div>
      <div :class="$style['option-meta-value']">
        {{value.type}}
      </div>
      <div :class="$style['option-meta-name']">Default</div>
      <div :class="$style['option-meta-value']">
        <button @click="copyCode"><code>{{value.default.text}}</code></button>
      </div>
      <div :class="$style['option-meta-name']">Example</div>
      <div :class="$style['option-meta-value']">
        <button @click="copyCode"><code>{{value.example.text}}</code></button>
      </div>
    </div>
  </div>
</div>

<script setup>
import { ref, onMounted } from 'vue'
import nixosModuleOptions from './options.mock.json';

const data = ref({});
const showModal = ref(false)

if (import.meta.env.PROD) {
  onMounted(() =>
    fetch('https://h-banii.github.io/LinuxMink/modules/nixos/options.json')
      .then(res => res.json)
      .then(json => data.value = json)
      .catch(console.log)
  )
} else {
  data.value = nixosModuleOptions;
};

function copyCode(event) {
  const text = event.srcElement.innerText;
  navigator.clipboard.writeText(text);
}
</script>

<style module>
.option-meta-container {
  display: grid !important;
  grid-template-columns: 100px 1fr;
  row-gap: .5em;
  column-gap: 1em;
}

.option-meta-name {
  text-align: right;
}

.option-meta-key {

}

button {
  font-size: unset;
}
</style>
