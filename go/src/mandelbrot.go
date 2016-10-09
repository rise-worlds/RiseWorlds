package main

import (
	"image"
	"image/color"
	"image/png"
	"log"
	"math/cmplx"
	"os"
)

func main() {
	const (
		xmin, ymin, xmax, ymax = -2, -2, +2, +2
		width, height          = 1024, 1024
	)
	img := image.NewNRGBA(image.Rect(0, 0, width, height))
	for py := 0; py < height; py++ {
		y := float64(py)/height*(ymax-ymin) + ymin
		for px := 0; px < width; px++ {
			x := float64(px)/width*(xmax-xmin) + xmin
			z := complex(x, y)

			//img.Set(px, py, mandelbrot(z))
			img.Set(px, py, mandelbrot2(z))
		}
	}
	file, err := os.Create("test.png")
	defer file.Close()
	if err != nil {
		log.Fatal(err)
	}
	png.Encode(file, img)
}

func mandelbrot(z complex128) color.Color {
	const iterations = 200
	const contrast = 15

	var v complex128
	for n := uint8(0); n < iterations; n++ {
		v = v*v + z
		if cmplx.Abs(v) > 2 {
			return color.Gray{255 - contrast*n}
		}
	}
	return color.Black
}

var (
	Red    = color.RGBA{0xFF, 0x00, 0x00, 0xFF}
	Orange = color.RGBA{0xFF, 0xA5, 0x00, 0xFF}
	Yellow = color.RGBA{0xFF, 0xFF, 0x00, 0xFF}
	Green  = color.RGBA{0x00, 0xFF, 0x00, 0xFF}
	Blue   = color.RGBA{0x00, 0x00, 0xFF, 0xFF}
	Indigo = color.RGBA{0x4B, 0x00, 0x82, 0xFF}
	Purple = color.RGBA{0x80, 0x00, 0x80, 0xFF}
)

var colors = []color.Color{Red, Orange, Yellow, Green, Blue, Indigo, Purple}

func mandelbrot2(z complex128) color.Color {
	const iterations = 200
	const contrast = 15

	var v complex128
	for n := uint8(0); n < iterations; n++ {
		v = v*v + z
		if cmplx.Abs(v) > 2 {
			//return color.Gray{255 - contrast*n}
			return colors[n%7]
		}
	}
	return color.Black
}
