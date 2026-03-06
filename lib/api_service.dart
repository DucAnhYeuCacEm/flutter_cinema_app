import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart';

class ApiService {
  // Sử dụng API giả lập từ JSONPlaceholder
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Movie>> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        
        // Chuyển đổi danh sách JSON thành danh sách Movie
        // Chúng ta chỉ lấy 10 mục đầu tiên để hiển thị menu phim gọn gàng
        List<Movie> movies = body
            .take(10)
            .map((dynamic item) => Movie.fromJson(item))
            .toList();
            
        return movies;
      } else {
        throw Exception("Không thể tải danh sách phim từ máy chủ");
      }
    } catch (e) {
      throw Exception("Lỗi kết nối: $e");
    }
  }
}