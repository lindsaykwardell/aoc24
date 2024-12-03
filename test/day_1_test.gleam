import gleeunit
import gleeunit/should
import day_1_input as input
import day_1

pub fn main() {
  gleeunit.main()
}

pub fn part_1_test() {
  day_1.calculate_distance(input.test_input) |> should.equal(Ok(11))
}

pub fn part_2_test() {
  day_1.calculate_similarity(input.test_input) |> should.equal(Ok(31))
}