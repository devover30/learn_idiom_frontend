<script setup lang="ts">
import { ref } from 'vue';
import { Toaster, toast } from 'vue-sonner'

const API_URL = import.meta.env.VITE_API_URL;
const idiom = ref({
  id: "",
  idiom_eng: "",
  idiom_hin: "",
})

async function getData() {
  let userId = localStorage.getItem("user_id");
  if (userId == null) {
    userId = generateSecureRandomString(16);
    localStorage.setItem("user_id", userId);
  }
  var data = new URLSearchParams();
  data.append('user', userId);
  const res = await fetch(`${API_URL}/idioms`, {
    method: "POST",
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: data
  });

  if (!res.ok) {
    const err = await res.json();
    console.log(err);
    toast.error(err.error);
    return;
  }

  const resData = await res.json();
  idiom.value = {
    id: resData.id,
    idiom_eng: resData.idiom_eng,
    idiom_hin: resData.idiom_hin
  };
}

function generateSecureRandomString(length: number) {
  const validCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let randomValues = new Uint8Array(length);
  window.crypto.getRandomValues(randomValues);
  return Array.from(randomValues).map((byte) => validCharacters[byte % validCharacters.length]).join('');
}

getData();

async function postIfRead() {
  const userId = localStorage.getItem("user_id");

  if (userId != null) {
    const data = new URLSearchParams();
    data.append("user", userId);

    const res = await fetch(`${API_URL}/idioms/${idiom.value.id}`, {
      method: "PUT",
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: data
    });

    if (!res.ok) {
      const err = await res.json();
      console.log(err);
      toast.error(err.error);
      return;
    }

    toast.success("Idiom Read Success");

  }
}
</script>

<template>
  <Toaster position="top-center" richColors />
  <main class="flex justify-center items-center h-full">
    <div class="p-6 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-800 dark:border-gray-700">
      <h5 class="mb-2 sm:text-xl font-bold tracking-tight text-gray-900 dark:text-white text-center">{{ idiom.idiom_eng
        }}</h5>
      <p class="mb-3 font-normal text-gray-700 dark:text-gray-400 text-center">({{ idiom.idiom_hin }})</p>
      <button @click="postIfRead"
        class="px-3 py-2 text-sm font-medium text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800 w-full mt-4">
        Read it
      </button>
    </div>
  </main>
</template>

<style scoped></style>
