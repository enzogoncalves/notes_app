import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/bloc/note_bloc/note_events.dart';
import 'package:notes_app/bloc/note_bloc/note_state.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_events.dart';
import 'package:notes_app/bloc/notes_bloc/notes_state.dart';
import 'package:notes_app/models/color.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/widgets/dialog.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late NoteBloc bloc;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final AppColors appColors = AppColors();

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = NoteBloc(notesRepository: context.read<NotesBloc>().notesRepository);

    return BlocListener<NoteBloc, NoteState>(
        bloc: bloc,
        listener: (_, state) {
          if (state is NoteEditedState) {
            context.read<NotesBloc>().add(NotesLoadEvent());
            Navigator.of(context).pop();
          } else if (state is NoteDeletedState) {
            context.read<NotesBloc>().add(NotesLoadEvent());
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, notesState) {
            if (notesState is NotesOpenNoteState) {
              Note note = notesState.note;

              titleController.text = note.title ?? "No Title";
              textController.text = note.text ?? "No Text";

              return SafeArea(
                child: Scaffold(
                  backgroundColor: appColors.backgroundColor,
                  appBar: AppBar(
                    backgroundColor: appColors.backgroundColor,
                    title: const Text("Note"),
                    centerTitle: true,
                    foregroundColor: appColors.mainTextColor,
                    leading: BlocBuilder<NoteBloc, NoteState>(
                        bloc: bloc,
                        builder: (context, state) {
                          if (state is NoteEditInProgressState) {
                            bool validForm = (note.title != titleController.text || note.text != textController.text) && (titleController.text.isNotEmpty && textController.text.isNotEmpty);

                            return IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                              ),
                              onPressed: () {
                                if (validForm) {
                                  dialogBuilder(
                                      context: context,
                                      dontExit: () {
                                        Navigator.of(context).pop();
                                      },
                                      exitWithoutSave: () {
                                        context.read<NotesBloc>().add(NotesLoadEvent());
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                } else {
                                  context.read<NotesBloc>().add(NotesLoadEvent());
                                  Navigator.pop(context);
                                }
                              },
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                              ),
                              onPressed: () {
                                context.read<NotesBloc>().add(NotesLoadEvent());
                                Navigator.pop(context);
                              },
                            );
                          }
                        }),
                    actions: [
                      BlocBuilder<NoteBloc, NoteState>(
                        bloc: bloc,
                        builder: (context, state) {
                          if (state is NoteEditInProgressState) {
                            bool validForm = (note.title != titleController.text || note.text != textController.text) && (titleController.text.isNotEmpty && textController.text.isNotEmpty);

                            return Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (validForm) {
                                      note.title = titleController.text;
                                      note.text = textController.text;

                                      bloc.add(NoteEditEvent(note: note));
                                    } else {}
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: validForm ? appColors.foregroundBlueColor : appColors.appBarDisableIconTextColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    titleController.text = note.title!;
                                    textController.text = note.text!;
                                    bloc.add(NoteReturnToInitialStateEvent());
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: appColors.mainRedColor),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    bloc.add(NoteEditingInProgressEvent());
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: appColors.mainTextColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    bloc.add(NoteDeleteEvent(note: note));
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: appColors.mainRedColor,
                                  ),
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(10),
                    child: BlocBuilder<NoteBloc, NoteState>(
                        bloc: bloc,
                        builder: (context, noteState) {
                          return Column(
                            children: [
                              TextFormField(
                                controller: titleController,
                                onChanged: (value) {
                                  titleController.text = value;
                                  bloc.add(NoteEditingInProgressEvent());
                                },
                                style: TextStyle(fontSize: 22, color: appColors.mainTextColor),
                                readOnly: noteState is! NoteEditInProgressState,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: textController,
                                onChanged: (value) {
                                  textController.text = value;
                                  bloc.add(NoteEditingInProgressEvent());
                                },
                                readOnly: noteState is! NoteEditInProgressState,
                                maxLines: null,
                                decoration: InputDecoration(
                                  label: note.text! == ""
                                      ? Text(
                                          "Insert your note here...",
                                          style: TextStyle(color: appColors.opacityTextColor),
                                        )
                                      : null,
                                  prefixStyle: TextStyle(color: appColors.mainTextColor),
                                  prefixText: (note.text! == "" && noteState is! NoteEditInProgressState) ? "Tap in the edit icon to edit" : "",
                                  alignLabelWithHint: true,
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(color: appColors.mainTextColor),
                              )
                            ],
                          );
                        }),
                  ),
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: appColors.backgroundColor,
                body: Center(
                    child: CircularProgressIndicator(
                  color: appColors.mainTextColor,
                )),
              );
            }
          },
        ));
  }
}
