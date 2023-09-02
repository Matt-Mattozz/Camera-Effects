# Camera effects
Enable and disable pre-made and custom camera effects

*  *  *

### How to apply camera effects

1. Require the module CameraEffects
2. To enable an effect, call the function CameraEffects.EnableEffect(effectName : string) , where effectName is the name of the module containing the effect
3. To disable an effect, call the function CameraEffects.DisableEffect(effectName : string) or CameraEffects.DisableAllEffects()

### How to create a custom camera effect

1. Create a ModuleScript that returns a function. In this function put the code of the effect
To obtain the local player's camera, use workspace.CurrentCamera
To obtain the local player's character, use game:GetService("Players").LocalPlayer

### Pre-made effects:

- Bounce : the camera goes up and down with respect to the CameraSubject
- Wobble : the camera goes in a circle around the CameraSubject

*  *  *

If you made a very good effect, or you think it may be helpful to the members of the community, open a pull request and your effect may end up in this repository!
