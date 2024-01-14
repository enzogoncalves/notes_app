import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/bloc/note_bloc/note_bloc.dart';
import 'package:notes_app/bloc/note_bloc/note_events.dart';
import 'package:notes_app/bloc/note_bloc/note_state.dart';
import 'package:notes_app/bloc/notes_bloc/notes_bloc.dart';
import 'package:notes_app/bloc/notes_bloc/notes_events.dart';
import 'package:notes_app/models/color.dart';
import 'package:notes_app/widgets/dialog.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
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
        listener: (context, state) {
          if (state is NoteCreatedState) {
            context.read<NotesBloc>().add(NotesLoadEvent());
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: appColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: appColors.backgroundColor,
              foregroundColor: appColors.mainTextColor,
              title: const Text("New Note"),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  if (titleController.text.isNotEmpty || textController.text.isNotEmpty) {
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
              ),
              actions: [
                TextButton(
                    onPressed: (titleController.text.isNotEmpty)
                        ? () {
                            bloc.add(NoteCreatedEvent(title: titleController.text, text: textController.text.isNotEmpty ? textController.text : ""));
                          }
                        : null,
                    child: BlocBuilder<NoteBloc, NoteState>(
                      bloc: bloc,
                      builder: (context, state) {
                        if (state is NoteCreateInProgessState) {
                          return const CircularProgressIndicator();
                        } else if (state is NoteCreateErrorState) {
                          return Icon(
                            Icons.error,
                            color: appColors.mainRedColor,
                          );
                        } else {
                          return Text(
                            "Save",
                            style: TextStyle(fontSize: 18, color: (titleController.text.isNotEmpty) ? appColors.foregroundBlueColor : appColors.appBarDisableIconTextColor),
                          );
                        }
                      },
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      onChanged: (value) {
                        setState(() {
                          titleController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                          label: Text(
                        "Title",
                        style: TextStyle(color: appColors.mainTextColor),
                      )),
                      style: TextStyle(color: appColors.mainTextColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textController,
                      onChanged: (value) {
                        setState(() {
                          textController.text = value;
                        });
                      },
                      minLines: 10,
                      maxLines: 15,
                      decoration: InputDecoration(
                        label: Text(
                          "Insert your note here...",
                          style: TextStyle(color: appColors.opacityTextColor),
                        ),
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: appColors.mainTextColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
