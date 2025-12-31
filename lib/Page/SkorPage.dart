import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:siwaspada/Service/RatingService.dart';

class SkorPage extends StatefulWidget {
  final int idTour;
  final String namaTour;

  const SkorPage({
    super.key,
    required this.idTour,
    required this.namaTour,
  });

  @override
  State<SkorPage> createState() => _SkorPageState();
}

class _SkorPageState extends State<SkorPage> {
  late Future<List<dynamic>> futureRatings;

  Map<String, dynamic>? myRating; // rating user login

  @override
  void initState() {
    super.initState();
    futureRatings = RatingService.getByTour(widget.idTour);
  }

  /// ================= RATA-RATA =================
  double averageRating(List ratings) {
    if (ratings.isEmpty) return 0;

    final total = ratings.fold<int>(
      0,
      (sum, r) => sum + (r['value'] as int),
    );

    return total / ratings.length;
  }

  /// ================= DISTRIBUSI =================
  double percentStar(List ratings, int star) {
    if (ratings.isEmpty) return 0;

    final count =
        ratings.where((r) => (r['value'] as int) == star).length;

    return count / ratings.length;
  }

  @override
  Widget build(BuildContext context) {
    final images = ["Image/bukit1.jpg", "Image/bukit2.jpg"];

    return Scaffold(
      backgroundColor: const Color(0xffFFF6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "SKOR",
          style: TextStyle(
            color: Color(0xff1AA4BC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureRatings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final ratings = snapshot.data ?? [];

          /// ===== SIMPAN RATING USER LOGIN (jika ada) =====
          myRating = ratings.isNotEmpty ? ratings.first : null;

          final avg = averageRating(ratings);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// ================= IMAGE =================
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CarouselSlider(
                    items: images
                        .map((img) => Image.asset(img, fit: BoxFit.cover))
                        .toList(),
                    options: CarouselOptions(
                      height: 170,
                      viewportFraction: 1,
                      autoPlay: true,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= SUMMARY =================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: List.generate(5, (i) {
                          final star = 5 - i;
                          return RatingBarRow(
                            star: star,
                            value: percentStar(ratings, star),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Text(
                          avg.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        StarRow(rating: avg.round()),
                        Text(
                          "${ratings.length}\nUlasan",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// ================= BUTTON =================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        showUlasanBottomSheet(context, myRating),
                    child: Text(
                      myRating == null
                          ? "Tulis Ulasan"
                          : "Edit Ulasan",
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// ================= LIST COMMENT =================
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Ulasan",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                ...ratings.map((r) => _commentItem(r)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ================= COMMENT ITEM =================
  Widget _commentItem(dynamic rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rating['users']['username'] ?? 'Anonim',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          StarRow(rating: rating['value']),
          if (rating['comment'] != null && rating['comment'] != "")
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(rating['comment']),
            ),
        ],
      ),
    );
  }

  /// ================= BOTTOM SHEET =================
  void showUlasanBottomSheet(
      BuildContext context, Map<String, dynamic>? existing) {
    int rating = existing?['value'] ?? 3;
    final commentCtrl =
        TextEditingController(text: existing?['comment'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.namaTour,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: i < rating
                              ? Colors.orange
                              : Colors.grey,
                        ),
                        onPressed: () =>
                            setSheet(() => rating = i + 1),
                      );
                    }),
                  ),

                  TextField(
                    controller: commentCtrl,
                    decoration:
                        const InputDecoration(hintText: "Tulis komentar"),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () async {
                      await RatingService.submitRating(
                        value: rating,
                        comment: commentCtrl.text,
                      );
                      Navigator.pop(context);
                      setState(() {
                        futureRatings =
                            RatingService.getByTour(widget.idTour);
                      });
                    },
                    child: const Text("SIMPAN"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// ================= STAR DISPLAY =================
class StarRow extends StatelessWidget {
  final int rating;
  const StarRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          Icons.star,
          size: 14,
          color: i < rating ? Colors.orange : Colors.grey.shade300,
        );
      }),
    );
  }
}

/// ================= BAR =================
class RatingBarRow extends StatelessWidget {
  final int star;
  final double value;

  const RatingBarRow({super.key, required this.star, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text("$star")),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.orange),
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}
