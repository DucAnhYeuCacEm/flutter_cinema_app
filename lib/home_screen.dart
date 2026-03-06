import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'api_service.dart';
import 'status_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> futureMovies;
  List<Movie> selectedMovies = [];
  final Color primaryRed = const Color(0xFFE50914);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Sửa lỗi load data: Tách biệt khởi tạo Future
  void _loadData() {
    final dataCall = ApiService().fetchMovies();
    setState(() {
      futureMovies = dataCall;
    });
  }

  double _calculateTotal() =>
      selectedMovies.fold(0, (sum, item) => sum + (item.ticketCount * 85.0));

  // Hàm xóa phim và giải phóng ghế dùng chung
  void _removeMovie(Movie movie) {
    setState(() {
      if (movie.seatNote.isNotEmpty) {
        // Tách chuỗi ghế và xóa khỏi danh sách đã đặt toàn cục
        List<String> seatsToRemove = movie.seatNote.split(', ');
        for (var seat in seatsToRemove) {
          globalOccupiedSeats.remove(seat.trim());
        }
      }
      movie.ticketCount = 0;
      movie.seatNote = "";
      selectedMovies.remove(movie);
    });
  }

  void _showBookingCart() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(25),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("VÉ ĐÃ CHỌN",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const Divider(color: Colors.white12, height: 30),
                Expanded(
                  child: selectedMovies.isEmpty
                      ? const Center(
                          child: Text("Giỏ vé trống",
                              style: TextStyle(color: Colors.white54)))
                      : ListView.builder(
                          itemCount: selectedMovies.length,
                          itemBuilder: (context, i) {
                            final movie = selectedMovies[i];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(movie.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text("Ghế: ${movie.seatNote}",
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 13)),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  // Cập nhật cả modal và màn hình chính
                                  setModalState(() {
                                    _removeMovie(movie);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                ),
                const Divider(color: Colors.white12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Tổng cộng:",
                          style: TextStyle(color: Colors.white)),
                      Text("${_calculateTotal().toStringAsFixed(0)}K VNĐ",
                          style: TextStyle(
                              color: primaryRed,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: primaryRed),
                      onPressed: selectedMovies.isEmpty
                          ? null
                          : () => Navigator.pop(context),
                      child: const Text("THANH TOÁN",
                          style: TextStyle(color: Colors.white)),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        // Tên bài thực hành của bạn
        title: const Text("TH3 - [Nguyễn Đức Anh] - [2251061700]",
            style: TextStyle(
                color: Color(0xFFE50914),
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Badge(
              label: Text("${selectedMovies.length}"),
              isLabelVisible: selectedMovies.isNotEmpty,
              backgroundColor: primaryRed,
              child: const Icon(Icons.confirmation_number_outlined,
                  color: Colors.white, size: 26),
            ),
            onPressed: _showBookingCart,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryRed));
          }
          if (snapshot.hasError) {
            return Center(
                child: TextButton(
                    onPressed: _loadData,
                    child: Text("THỬ LẠI",
                        style: TextStyle(color: primaryRed))));
          }

          final allMovies = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: allMovies.length,
            itemBuilder: (context, index) {
              final m = allMovies[index];
              final isBooked = selectedMovies.contains(m);
              return Card(
                color: const Color(0xFF2F2F2F),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isBooked
                      ? BorderSide(color: primaryRed, width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  onTap: () => _openSeatSelection(m),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(m.imageUrl,
                        width: 50, height: 75, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                      return Container(
                          width: 50, color: Colors.white10, child: const Icon(Icons.movie));
                    }),
                  ),
                  title: Text(m.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  subtitle: Text(
                      isBooked
                          ? "Đã chọn: ${m.seatNote}"
                          : "${m.genre} • ${m.duration}",
                      style: TextStyle(
                          color: isBooked ? primaryRed : Colors.white54,
                          fontSize: 11)),
                  trailing: isBooked
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.white24),
                          onPressed: () => _removeMovie(m))
                      : const Icon(Icons.add_circle_outline,
                          color: Colors.white12),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openSeatSelection(Movie movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MovieCustomizer(
        movie: movie,
        onSave: (count, seats) {
          setState(() {
            movie.ticketCount = count;
            movie.seatNote = seats;
            if (!selectedMovies.contains(movie)) selectedMovies.add(movie);
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}