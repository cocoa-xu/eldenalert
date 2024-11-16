<img src="https://github.com/cocoa-xu/eldenalert/raw/main/assets/repository-open-graph.png" alt="Logo">

## Screenshot
![screenshot](assets/eldenalert.jpg)

## Usage

### Default

The following command is the equivalent of running `eldenalert -text 'SOMETHING HAPPENED'`, i.e., using the default settings.

```bash
$ eldenalert -text 'SOMETHING HAPPENED'
$ eldenalert -text 'SOMETHING HAPPENED' \
  -style victory \
  -dismiss 3 \
  -screen active \
  -sound on \
```

### Customization

- `-text`: The text to display in the alert.
- `-style`: The style of the alert. The available styles are `victory` and `death` for now.
- `-dismiss`: The time in seconds before the alert is dismissed.
- `-screen`: The screen to display the alert on. The available screens are `active` and `all`.
- `-sound`: The sound to play when the alert is displayed. The available sounds are `on` and `off`.

## Usage of 3rd party resources

### Sound

Sound effects in this project are from the game "Elden Ring" developed by FromSoftware, Inc. The sound effects are used for non-commercial purposes only.

### Font

The font used in this project is "Agmena Pro". The font is used for non-commercial purposes only.
