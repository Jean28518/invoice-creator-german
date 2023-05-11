/// If unparsable returns 0.0
double parseDouble(String s) {
  // Check if double
  if (s.contains(",")) {
    s = s.replaceAll(",", ".");
  }
  if (double.tryParse(s) != null) {
    return double.parse(s);
  }
  return 0.0;
}
