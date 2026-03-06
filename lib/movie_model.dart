class Movie {
  final int id;
  final String title;
  final String genre;
  final double rating;
  final String duration;
  final String imageUrl;
  int ticketCount; 
  String seatNote;  

  Movie({
    required this.id, required this.title, required this.genre, 
    required this.rating, required this.duration, required this.imageUrl,
    this.ticketCount = 0, this.seatNote = "",
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    
    // Dữ liệu phim khớp với từ khóa ảnh
    final movieData = {
      1: {"title": "Spider-Man: No Way Home", "kw": "spiderman", "genre": "Hành động", "time": "148 phút"},
      2: {"title": "A Quiet Place", "kw": "horror", "genre": "Kinh dị", "time": "97 phút"},
      3: {"title": "Interstellar", "kw": "space,galaxy", "genre": "Khoa học", "time": "169 phút"},
      4: {"title": "The Dark Knight", "kw": "batman", "genre": "Hành động", "time": "152 phút"},
      5: {"title": "Avatar: The Way of Water", "kw": "ocean,blue", "genre": "Phiêu lưu", "time": "192 phút"},
      6: {"title": "Your Name", "kw": "anime", "genre": "Hoạt hình", "time": "106 phút"},
      7: {"title": "John Wick 4", "kw": "killer,gun", "genre": "Hành động", "time": "169 phút"},
      8: {"title": "Inception", "kw": "dream", "genre": "Hành động", "time": "148 phút"},
      9: {"title": "The Lion King", "kw": "lion,animal", "genre": "Gia đình", "time": "118 phút"},
      10: {"title": "Doctor Strange", "kw": "magic", "genre": "Ảo thuật", "time": "126 phút"},
    };

    String title = movieData[id]?["title"] ?? "Bom tấn #$id";
    String kw = movieData[id]?["kw"] ?? "movie";
    
    return Movie(
      id: id,
      title: title,
      genre: movieData[id]?["genre"] ?? "Viễn tưởng",
      rating: 8.0 + (id % 10) / 5,
      duration: movieData[id]?["time"] ?? "120 phút",
      // Dùng tỉ lệ 300x450 cho poster phim dọc
      imageUrl: "https://loremflickr.com/300/450/$kw/all?lock=$id",
    );
  }
}