class VideoFX {
  constructor() {
    this.filters = ["grayscale", "sepia", "noir", "psychedelic", "none"]
  }

  cycleFilter() {
    const filter = this.filters.shift()
    this.filters.push(filter)
    return filter
  }
}

export { VideoFX }