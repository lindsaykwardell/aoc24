import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import day_1_input as input

pub fn main() {
  let input = input.input

  case calculate_distance(input) {
    Ok(distance) -> io.println("Distance: " <> int.to_string(distance))
    Error(_) -> io.println_error("Error")
  }

  case calculate_similarity(input) {
    Ok(similarity) -> io.println("Similarity: " <> int.to_string(similarity))
    Error(_) -> io.println_error("Error")
  }
}

fn get_lists(input: String) -> #(List(Int), List(Int)) {
  string.split(input, "\n")
  |> list.map(fn(x) {
    case string.split(x, "   ") {
      [a, b] ->
        case int.parse(a), int.parse(b) {
          Ok(a_), Ok(b_) -> Ok(#(a_, b_))
          _, _ -> Error("Invalid input")
        }
      _ -> Error("Invalid input")
    }
  })
  |> list.fold(#([], []), fn(acc, x) {
    case x {
      Ok(#(a, b)) -> #(list.append(acc.0, [a]), list.append(acc.1, [b]))
      Error(_) -> acc
    }
  })
}

pub fn calculate_distance(input: String) -> Result(Int, Nil) {
  get_lists(input)
  |> fn(lists) {
    list.zip(
      lists.0 |> list.sort(int.compare),
      lists.1 |> list.sort(int.compare),
    )
  }
  |> list.map(fn(pair) { int.absolute_value(pair.1 - pair.0) })
  |> list.reduce(int.add)
}

pub fn calculate_similarity(input: String) -> Result(Int, Nil) {
  let #(a, b) = get_lists(input)
  let scores: dict.Dict(Int, Int) =
    b
    |> list.unique
    |> list.fold(dict.new(), fn(acc, x) {
      list.filter(b, fn(y) { x == y })
      |> fn(result) { list.length(result) * x }
      |> dict.insert(acc, x, _)
    })

  list.map(a, fn(x) {
    case dict.get(scores, x) {
      Ok(score) -> score
      Error(_) -> 0
    }
  })
  |> list.reduce(int.add)
}
