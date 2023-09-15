# Camera effects
Enable and disable pre-made and custom camera effects

Definitions:
- *Effect* : a function that updates the CurrentCamera's CFrame (this means that you have to interact with the module client-side). Once it ends the CurrentCamera's properties will be reset to the values it had before the effect was applied
- *Sustained effect* : an effect that is applied until it is explicitly stopped by calling a function (the functions are covered in the following section)
- *Once effect* : an effect with a fixed duration, that doesn't require the call of a function to be stopped

## How to apply camera effects

### Sustained
- Enable effect: `CameraEffects.EnableEffect(effect : SustainedEffect)`

- Disable effect: `CameraEffects.DisableEffect(effect : SustainedEffect)`

- Disable all effects: `CameraEffects.DisableAllEffects()`

A list of pre-made effects is contained in `CameraEffects.SustainedEffectsList`
  
### Once
W.I.P.

## How to create a custom camera effect

### Sustained
Create a `ModuleScript` that returns a function.

This function must accept as first parameter a `number`, which represents the time since the effect was enabled, and must return a `Vector3`. Inside the function put the code of the effect. 

The module will look something like this:
```lua
-- Example ModuleScript name: ExampleEffect
return function(now : int, ... : any)
    -- code here
    return Vector3.new(0, 0, 0)
end
```

To then activate the effect simply do `CameraEffects.EnableEffect(effectName)` (in this example `CameraEffects.EnableEffect(ExampleEffect)`)

### Once: 
W.I.P.

## Pre-made effects:

### Sustained
- `Bounce` : the camera goes up and down with respect to the CameraSubject

  ![Bounce](https://github.com/Matt-Mattozz/Camera-Effects/assets/101893693/3c45290c-8268-4a98-bbb8-6941c06dae7e)

- `Wobble` : the camera goes in a circle around the CameraSubject
    
  ![Wobble](https://github.com/Matt-Mattozz/Camera-Effects/assets/101893693/20855ce8-7ed6-4f30-ae9d-63e8f3220850)

### Once:
W.I.P.

## Feedback

If you'd like to improve the code, fix bugs and / or mistakes, or add new effects that could be useful to other users, please open a pull request! Any help is greatly appreaciated!
