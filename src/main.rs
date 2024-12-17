use pixels::{Pixels, SurfaceTexture};
use std::time::Duration;
use winit::{event_loop::EventLoop, window::WindowBuilder};

fn main() {
    let event_loop = EventLoop::new().unwrap();

    let window = WindowBuilder::new()
        .with_title("FLASHBANG!")
        .build(&event_loop)
        .unwrap();

    let window_size = window.inner_size();

    let surface_texture = SurfaceTexture::new(window_size.width, window_size.height, &window);

    let mut pixels = Pixels::new(window_size.width, window_size.height, surface_texture).unwrap();

    let mut alpha: u8 = 255;

    while alpha > 0 {
        for pixel in pixels.frame_mut().chunks_mut(4) {
            pixel[0] = 255; // Red
            pixel[1] = 255; // Green
            pixel[2] = 255; // Blue
            pixel[3] = alpha; // Alpha (255 is opaque)
        }

        alpha = alpha.saturating_sub(2);

        pixels.render().unwrap();
    }

    std::thread::sleep(Duration::from_millis(1000));
}
