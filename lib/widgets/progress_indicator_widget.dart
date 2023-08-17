import 'package:flutter/material.dart';

class CustomProgressIndicatorWidget extends StatelessWidget {
  bool cancellable;
  void Function()? onCancel;
  CustomProgressIndicatorWidget({
    Key? key,
    this.cancellable = false,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 100,
        constraints: const BoxConstraints.expand(),
        decoration:
            const BoxDecoration(color: Color.fromARGB(100, 105, 105, 105)),
        child: FittedBox(
          fit: BoxFit.none,
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              ...cancellable
                  ? [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red),
                          onPressed: () {
                            onCancel?.call();
                          },
                          child: const Text("キャンセル"))
                    ]
                  : []
            ],
          ),
        ),
      ),
    );
  }
}
