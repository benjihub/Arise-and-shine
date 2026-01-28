import 'package:arise_and_shine/components/network_image_with_loader.dart';
import 'package:arise_and_shine/constants/constants.dart';
import 'package:arise_and_shine/widgets/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookstoreScreen extends StatelessWidget {
  const BookstoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Firestore reference to the "books" collection
    final booksRef = FirebaseFirestore.instance.collection('books');

    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust the size of grid items based on screen width
    final itemWidth = screenWidth / 2 - 20;
    final itemHeight = itemWidth * 1.5;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "bookstore".tr,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: booksRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: loadingIndicator(color: goldenColor),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Failed to load books.",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No books available at the moment.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          // Parse Firestore documents into a list of books
          final books = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: itemWidth / itemHeight,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final bookData = books[index].data() as Map<String, dynamic>;
                final bookTitle = bookData['title'] ?? 'Untitled';
                final bookCover =
                    bookData['coverUrl'] ?? 'https://via.placeholder.com/150';
                // final bookPrice = bookData['price'] ?? 'Free';

                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: itemHeight * 0.75,
                              width: double.infinity,
                              child: NetworkImageWithLoader(
                                bookCover,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            bookTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        // const Spacer(),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 8.0,
                        //     vertical: 4.0,
                        //   ),
                        //   child: Text(
                        //     bookPrice == 'Free'
                        //         ? 'Free'
                        //         : '\$${bookPrice.toString()}',
                        //     style: const TextStyle(
                        //       color: primaryColor,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
