# Snippets
Collection of useful Powershell snippets

# Format
Many of the snippets are wrapped in script blocks.
This is to allow them to be easily pasted into a console/ terminal in one go.
Prevents `try ... catch ...`, etc errors when pasting.

```
&{
    try {
        # do something
    }
    catch {
        Write-Host $_.Exception.Message -Foreground Red
    }
}
```
