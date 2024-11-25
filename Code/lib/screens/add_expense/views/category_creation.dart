import 'package:expense_repository/expense_repository.dart';
import '../blocs/create_category/create_category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

Future getCategoryCreation(BuildContext context) {
  List<String> myCategoryIcons = [
    'entertainment',
    'food',
    'home',
    'pet',
    'shopping',
    'tech',
    'travel'
  ];

  return showDialog(
      context: context,
      builder: (ctx) {
        bool isExpanded = false;
        String iconSelected = '';
        Color categoryColor = Colors.white;
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController categoryIconController = TextEditingController();
        TextEditingController categoryColorController = TextEditingController();
        bool isLoading = false;
        Category category = Category.empty;

        return BlocProvider.value(
          value: context.read<CreateCategoryBloc>(),
          child: StatefulBuilder(
            builder: (ctx, setState) =>
                BlocListener<CreateCategoryBloc, CreateCategoryState>(
              listener: (context, state) {
                if (state is CreateCategorySuccess) {
                  Navigator.pop(ctx, category);
                } else if (state is CreateCategoryLoading) {
                  setState(
                    () {
                      isLoading = true;
                    },
                  );
                } else {
                  const Center(child: Text('An Error Occured!'));
                }
              },
              child: AlertDialog(
                title: const Center(child: Text('Create a category')),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: categoryNameController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Name',
                            prefixIcon: Icon(FontAwesomeIcons.idBadge,
                                size: 18, color: Colors.grey.shade500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: categoryIconController,
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        readOnly: true,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Icon',
                            prefixIcon: Icon(FontAwesomeIcons.icons,
                                size: 18, color: Colors.grey.shade500),
                            suffixIcon: isExpanded
                                ? Icon(FontAwesomeIcons.chevronUp,
                                    size: 18, color: Colors.grey.shade500)
                                : Icon(FontAwesomeIcons.chevronDown,
                                    size: 18, color: Colors.grey.shade500),
                            border: OutlineInputBorder(
                                borderRadius: isExpanded
                                    ? const BorderRadius.vertical(
                                        top: Radius.circular(12))
                                    : BorderRadius.circular(12),
                                borderSide: BorderSide.none)),
                      ),
                      isExpanded
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5),
                                  itemCount: myCategoryIcons.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          iconSelected = myCategoryIcons[index];
                                        });
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: iconSelected ==
                                                        myCategoryIcons[index]
                                                    ? Colors.green
                                                    : Colors.grey.shade200),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/${myCategoryIcons[index]}.png'),
                                                scale: 1.5)),
                                      ),
                                    );
                                  },
                                ),
                              ))
                          : Container(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: categoryColorController,
                        readOnly: true,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx2) {
                                return AlertDialog(
                                    content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorPicker(
                                        pickerColor: categoryColor,
                                        onColorChanged: (value) {
                                          setState(() {
                                            categoryColor = value;
                                          });
                                        }),
                                    SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx2);
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12))),
                                          child: const Text(
                                            'Save Color',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ));
                              });
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: categoryColor,
                            hintText: 'Color',
                            prefixIcon: Icon(FontAwesomeIcons.palette,
                                size: 18, color: Colors.grey.shade500),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                          width: double.infinity,
                          height: kToolbarHeight,
                          child: isLoading == true
                              ? const Center(child: CircularProgressIndicator())
                              : TextButton(
                                  onPressed: () {
                                    // Create category object and pop the context.
                                    setState(() {
                                      category.categoryId = const Uuid().v1();
                                      category.name =
                                          categoryNameController.text;
                                      category.icon = iconSelected;
                                      category.color = categoryColor.value;
                                    });
                                    context
                                        .read<CreateCategoryBloc>()
                                        .add(CreateCategory(category));
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12))),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
