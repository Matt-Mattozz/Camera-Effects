# Camera effects
Enable and disable pre-made and custom camera effects

*  *  *

### How to apply camera effects

- Sustained effects:
    - Enable effect: `CameraEffects.EnableEffect(CameraEffects.SustainedEffectsList[effectName])`
    - Disable effect: `CameraEffects.DisableEffect(CameraEffects.SustainedEffectsList[effectName])` or `CameraEffects.DisableAllEffects()`
- Once effects: W.I.P.

### How to create a custom camera effect

- Sustained: Create a ModuleScript that returns a function. This function must accept as first parameter a number, which represents the effect progression (like a os.clock(), but relative to the total time the effect has been running for), and must return a Vector3. Inside the function put the code of the effect
- Once: W.I.P.

### Pre-made effects:

- Sustained
    - `Bounce` : the camera goes up and down with respect to the CameraSubject
    - `Wobble` : the camera goes in a circle around the CameraSubject
- Once: W.I.P.

*  *  *

If you made a very good effect, or you think it may be helpful to the members of the community, open a pull request and your effect may end up in this repository!