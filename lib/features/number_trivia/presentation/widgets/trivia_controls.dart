import 'package:clean_arch_tutorial/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            _dispatchConcrete();
          },
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
              child: Text('Search'),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: _dispatchConcrete,
            )),
            SizedBox(width: 10.0),
            Expanded(
                child: RaisedButton(
              child: Text('Get random Trivia'),
              onPressed: _dispatchRandom,
            ))
          ],
        )
      ],
    );
  }

  void _dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void _dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
