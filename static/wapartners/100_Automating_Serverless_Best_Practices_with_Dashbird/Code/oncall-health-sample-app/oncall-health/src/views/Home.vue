

<template>
  <div class="home">
   
      <menus class="site-header" showTitle="true" />
    
  <section class="home-about">
    <div class="row column large-9 xlarge-6 xxlarge-4">
      <h2 class="section-title">How Does This Work?</h2>
      <p class="content">
        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
      </p>
    </div>

    <div class="row medium-up-2 large-up-4">
      <div class="column">
        <div class="home-about-block">
          <h3 class="title icon-download">Download The App</h3>
          <p class="content">Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.</p>
        </div>
      </div>

      <div class="column">
        <div class="home-about-block">
          <h3 class="title icon-carunit">Pick a Location</h3>
          <p class="content">When an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.s</p>
        </div>
      </div>

      <div class="column">
        <div class="home-about-block">
          <h3 class="title icon-carunit">Request BlueCar</h3>
          <p class="content">It has survived not only five centuries, but also the leap into electronic typesetting.</p>
        </div>
      </div>

      <div class="column">
        <div class="home-about-block">
          <h3 class="title icon-carunit">Get your Help</h3>
          <p class="content">It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus.</p>
        </div>
      </div>
    </div>
  </section>


    <footers />
  </div>
</template>

<script>
// @ is an alias to /src
import footers from '@/components/footer.vue'
import menu from '@/components/menu.vue'

export default {
  name: 'home',
  components: {
    footers: footers,
    menus: menu
  },
}

</script>
