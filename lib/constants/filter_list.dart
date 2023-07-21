


import 'package:qfoods/model/FilterModel.dart';

List<FilterModel> filter_list = [

FilterModel(title: "Veg", selected: "", type: "radio", 
filter_type: "veg",
options: [
  Options(attribute_id: "1",attributeName: "Veg", value: "0", type: "veg"),
  Options(attribute_id: "2",attributeName: "Non Veg", value: "1", type: "non_veg")
]),
FilterModel(title: "Sort", selected: "", type: "radio", 
filter_type: "sort",
options: [
  Options(attribute_id: "3",attributeName: "Cost: Low to High", value: "price", type: "asc"),
  Options(attribute_id: "4",attributeName: "Cost High to Low", value: "price", type: "desc")
]),
FilterModel(title: "Cost for two", selected: "", type: "radio",
filter_type: "price", 
options: [
   Options(attribute_id: "5",attributeName: "Rs 100 - Rs 200", maxPrice: "200", minPrice: "100"),
  Options(attribute_id: "6",attributeName: "Less Than 100", type: "less", value: "100"),
   Options(attribute_id: "7",attributeName: "Greater Than 300", type: "more", value: "300")
]),

FilterModel(title: "Rating", selected: "", type: "radio",
filter_type: "rating", 
options: [
   Options(attribute_id: "8",attributeName: "Rating : (High to Low)", type: "rating", value: "desc"),
   Options(attribute_id: "9",attributeName: "Rating : (Low to High)", type: "rating", value: "asc"),
 
])

];