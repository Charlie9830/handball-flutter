import 'package:flutter/material.dart';

const String _warning = 'Are you sure you want to delete your account?';

const String _subWarning = 'This action is permanent.';

const String _mainBody =
    'If you proceed, all Tasks, Lists and Comments you created in projects you currently ' +
        'aren’t sharing will be deleted. You will be removed from any shared projects you are a part of, however ' +
        'anything you created in those projects will be left. If you have any queries please contact us at';
const String _email = 'support@handballapp.io';
const String _sendOff =
    'Sad to see you go. We hope to see you again soon. All the best!';

class DeleteAccountConfirmationText extends StatelessWidget {
  const DeleteAccountConfirmationText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentTextColor = Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.secondaryVariant : Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(_warning,
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: accentTextColor)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(_subWarning, style: Theme.of(context).textTheme.headline),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(_mainBody),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(_email, style: Theme.of(context).textTheme.body1.copyWith(color: accentTextColor, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(_sendOff),
        ),
      ],
    );
  }
}
