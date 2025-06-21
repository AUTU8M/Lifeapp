import 'package:flutter/material.dart';
import 'package:lifelab3/src/teacher/teacher_profile/provider/teacher_profile_provider.dart';

void teacherBoardListBottomSheet(
    BuildContext context, TeacherProfileProvider provider) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... existing header code ...

                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
                    child: ListenableBuilder(
                      listenable: provider,
                      builder: (context, _) {
                        if (provider.boardModel?.data?.boards == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Column(
                          children:
                              provider.boardModel!.data!.boards!.map((board) {
                            bool isSelected = provider.boardId == board.id;
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (board.id != null &&
                                        board.name != null) {
                                      provider.updateBoard(
                                        board.id!,
                                        board.name!,
                                      );

                                      // Close the bottom sheet after successful update
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            board.name ?? "",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isSelected
                                                  ? Colors.blue
                                                  : Colors.black87,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (board !=
                                    provider.boardModel!.data!.boards!.last)
                                  const Divider(height: 1),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
