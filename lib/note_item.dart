import 'package:note_app/home_screen.dart';
import 'package:note_app/note.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note_item_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/services/repository.dart';

class NoteItem extends StatelessWidget {
  NoteItem({this.note});

  final passwordController = TextEditingController();
  final Note note;

  _deleteTap(BuildContext context, String id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Are you sure?",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Dismiss"),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await NoteRepository().deleteNote(id);
                              // homeScreenCallback();
                              Navigator.pop(context);
                            },
                            child: Text("Yes"),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 20.0, bottom: 2.0),
      color: Colors.green,
      child: InkWell(
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => NoteItemDialog(note: note));
          },
          child: Column(children: <Widget>[
            Slidable(
              key: ValueKey(note.title),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'More',
                  color: Colors.grey.shade200,
                  icon: Icons.more_horiz,
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    // setState(() {
                    _deleteTap(context, note.id);
                    // });
                  },
                ),
              ],
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
              ),
              child: ListTile(
                title: Text(note.title),
              ),
            )
          ])));
}
