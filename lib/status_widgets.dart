import 'package:flutter/material.dart';
import 'movie_model.dart';

// Biến lưu trữ toàn bộ ghế đã đặt trên hệ thống
List<String> globalOccupiedSeats = []; 

class MovieCustomizer extends StatefulWidget {
  final Movie movie;
  final Function(int, String) onSave;

  const MovieCustomizer({super.key, required this.movie, required this.onSave});

  @override
  State<MovieCustomizer> createState() => _MovieCustomizerState();
}

class _MovieCustomizerState extends State<MovieCustomizer> {
  List<String> selectedSeats = [];
  final List<String> rows = ['A', 'B', 'C', 'D'];
  final int cols = 5;

  @override
  void initState() {
    super.initState();
    if (widget.movie.seatNote.isNotEmpty) {
      selectedSeats = widget.movie.seatNote.split(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("SƠ ĐỒ CHỌN GHẾ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 20),
          
          // --- BẢNG CHÚ THÍCH TRẠNG THÁI GHẾ ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNote(Colors.white10, "Chưa đặt"),
              _buildNote(Colors.red, "Ghế bạn chọn"),
              _buildNote(Colors.white38, "Đã đặt"),
            ],
          ),
          const SizedBox(height: 25),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, mainAxisSpacing: 10, crossAxisSpacing: 10
            ),
            itemCount: rows.length * cols,
            itemBuilder: (context, index) {
              String seat = "${rows[index ~/ cols]}${index % cols + 1}";
              bool isOccupiedByOthers = globalOccupiedSeats.contains(seat) && !selectedSeats.contains(seat);
              bool isChoosing = selectedSeats.contains(seat);

              return GestureDetector(
                onTap: isOccupiedByOthers ? null : () {
                  setState(() {
                    isChoosing ? selectedSeats.remove(seat) : selectedSeats.add(seat);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isOccupiedByOthers ? Colors.white24 : (isChoosing ? Colors.red : Colors.white10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isChoosing ? Colors.white : Colors.white24),
                  ),
                  child: Center(
                    child: Text(seat, style: TextStyle(
                      color: isOccupiedByOthers ? Colors.white38 : Colors.white,
                      decoration: isOccupiedByOthers ? TextDecoration.lineThrough : null,
                    )),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 15)),
            onPressed: selectedSeats.isEmpty ? null : () {
              if (widget.movie.seatNote.isNotEmpty) {
                List<String> oldSeats = widget.movie.seatNote.split(', ');
                for (var s in oldSeats) globalOccupiedSeats.remove(s.trim());
              }
              globalOccupiedSeats.addAll(selectedSeats);
              widget.onSave(selectedSeats.length, selectedSeats.join(', '));
            },
            child: const Text("XÁC NHẬN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }

  // Widget hỗ trợ vẽ chú thích
  Widget _buildNote(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}