A case study on the pretty ice block shaders from Celeste:

![celeste gif](https://media.giphy.com/media/f6mijS2HXnJVJgPqA2/giphy.gif)

Here's my end result:

![end result](https://media3.giphy.com/media/RNcOWp2YsPdkiDDVhE/giphy.gif)

I'm pretty proud of this one! I was able to implement the sparkly animations using only shaders and a single texture with colored dots per layer. The distortion looks decently good too, although the lines in the original never really "break" like you see mine do.

Check out the [shaders](https://github.com/japhib/celesteShaderCaseStudy1/tree/master/shaders) folder for the actual shader code I used.

See [iceblock.lua](https://github.com/japhib/celesteShaderCaseStudy1/blob/master/iceblock.lua) for the Lua/Love2D code used to invoke the shaders.