/// Step

// Fade in and out
image_alpha += AlphaInc;

if (image_alpha >= Alpha) { image_alpha = Alpha; AlphaInc *= -1; }
if (image_alpha <= 0.1) { image_alpha = 0.1; AlphaInc *= -1; }