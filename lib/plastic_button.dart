import 'package:flutter/material.dart';

class PlasticButton extends StatefulWidget {
  const PlasticButton({super.key, required this.plasticType, required this.plasticId, required this.callback});

  final int plasticId;
  final String plasticType;
  final Function callback;

  @override
  State<PlasticButton> createState() => _PlasticButtonState();
}

class _PlasticButtonState extends State<PlasticButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
        onPressed: () {
          sendDialog(widget.plasticType);
        },
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(widget.plasticId.toString(), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w700, fontSize: 48)),
            const SizedBox(width: 25),
            Text(widget.plasticType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24))
          ],
        ));
  }

  void sendDialog(String plastic) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.transparent,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: height * 0.1,
                    width: width * 0.2,
                    child: SizedBox(
                      height: height * 0.2 - 45,
                      width: width * 0.2,
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          const Icon(Icons.question_mark_rounded, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text("Are you sure you this is $plastic?",
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 16))
                        ]),
                        const SizedBox(height: 5),
                        Row(children: [Expanded(child: Container(height: 1, color: Colors.blue))]),
                        const SizedBox(height: 10),
                        const Expanded(child: SizedBox()),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Container(
                                width: width * 0.17,
                                height: 50,
                                decoration: BoxDecoration(border: Border.all(width: 0.5), borderRadius: BorderRadius.circular(5)),
                                child: ElevatedButton(
                                    onPressed: () async {
                                      widget.callback(widget.plasticId);
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                        shadowColor: MaterialStateProperty.all(Colors.transparent)),
                                    child: Row(children: [
                                      const SizedBox(width: 10),
                                      const Icon(Icons.check, color: Colors.white),
                                      const SizedBox(width: 20),
                                      Text("Yes, this is $plastic", style: const TextStyle(color: Colors.white)),
                                      const Expanded(child: SizedBox())
                                    ]))),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Container(
                              width: width * 0.17,
                              height: 50,
                              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(Colors.transparent)),
                                  child: Row(
                                    children: const [
                                      SizedBox(width: 10),
                                      Icon(Icons.cancel, color: Colors.blue),
                                      SizedBox(width: 20),
                                      Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      Expanded(child: SizedBox()),
                                    ],
                                  )),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                      ]),
                    )));
          }));
        });
  }
}
