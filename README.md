# Persian Easy Date Picker

**Persian Easy Date Picker** is a feature-rich and customizable Persian date picker package for Flutter applications. It supports various configurations, such as custom colors, past and future date selection, and blurred backgrounds, making it perfect for any Persian date-picking needs.
<p align="center">
  <img src="https://raw.githubusercontent.com/AmirrezaKhezerlou/persian_easy_date_picker/refs/heads/main/Screenshot_20241229_193809.png" alt="Persian Easy Date Picker Screenshot" width="300">
</p>
## Features

- **Customizable UI**: Change border radius, colors, texts, and more.
- **Stepper Navigation**: Option to show a stepper for year, month, and day selection.
- **Past and Future Date Restrictions**: Configure whether users can pick dates from the past or future.
- **Blurred Background**: Add a stylish blurred background for dialogs.
- **Error Handling**: Custom callback for handling errors.

---

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  persian_easy_date_picker: latest_version
```

Then run:

```bash
flutter pub get
```

---

## Usage

Here is an example of how to use Persian Easy Date Picker in your Flutter project:

```dart
import 'package:persian_easy_date_picker/persian_easy_date_picker.dart';

void selectDate(BuildContext context) async {
  String? selectedDate = await PersianDatePicker.pick(
    context: context,
    onError: (error) {
      print('Error: $error');
    },
    showStepper: true,
    borderRadius: 7.0,
    blurredBackground: true,
    startYear: 1380,
    endYear: 1408,
    autoPick: false,
  );

  if (selectedDate != null) {
    print('Selected Date: $selectedDate');
  }
}
```

---

## Parameters

The `pick` function accepts several parameters for customization:

| Parameter             | Type               | Default Value       | Description                                         |
| --------------------- | ------------------ | ------------------- | --------------------------------------------------- |
| `context`             | `BuildContext`     | **Required**        | The build context for showing dialogs.              |
| `onError`             | `Function(String)` | **Required**        | Callback for handling errors or invalid selections. |
| `showStepper`         | `bool`             | `true`              | Enables or disables stepper navigation.             |
| `startYear`           | `int`              | `1290`              | The earliest year available for selection.          |
| `endYear`             | `int`              | `1480`              | The latest year available for selection.            |
| `title`               | `String`           | `"انتخاب تاریخ"`    | The title of the picker dialogs.                    |
| `borderRadius`        | `double`           | `8.0`               | Radius for dialog borders.                          |
| `backgroundColor`     | `Color`            | `Color(0xFFFFFFFF)` | Background color of the picker dialogs.             |
| `textColor`           | `Color`            | `Color(0xFF000000)` | Text color of the picker dialogs.                   |
| `canSelectPastTime`   | `bool`             | `true`              | Whether past dates can be selected.                 |
| `canSelectFutureTime` | `bool`             | `true`              | Whether future dates can be selected.               |
| `blurredBackground`   | `bool`             | `false`             | Adds a blurred effect to the background.            |
| `autoPick`            | `bool`             | `true`              | Automatically picks the first valid selection.      |
| `nextButtonColor`     | `Color`            | `Colors.blue`       | Color of the "Next" button.                         |
| `nextButtonText`      | `String`           | `"ادامه"`           | Text of the "Next" button.                          |
| `doneButtonText`      | `String`           | `"پایان"`           | Text of the "Done" button.                          |
| `cancelButtonColor`   | `Color`            | `Colors.red`        | Color of the "Cancel" button.                       |
| `cancelButtonText`    | `String`           | `"لغو"`             | Text of the "Cancel" button.                        |

---

## Example

To use this package, wrap your date-picking logic inside a widget or a function:

```dart
ElevatedButton(
  onPressed: () => selectDate(context),
  child: Text('Pick Date'),
);
```

---

## Error Handling

The `onError` callback handles any errors or invalid selections, such as:

- Selecting a past date when `canSelectPastTime` is `false`.
- Selecting a future date when `canSelectFutureTime` is `false`.
- Dismissing the dialog without making a selection.

Example:

```dart
onError: (error) {
  print('Error: $error');
}
```

---

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## License

This package is licensed under the [MIT License](LICENSE).

---

## Contact

For questions, issues, or suggestions, please contact:

- **Email**: [[mrkhezerlou@gmail.com](mailto\:mrkhezrlou@gmail.com)]
- **GitHub**: [Your GitHub Profile]

---

Enjoy using Persian Easy Date Picker!

