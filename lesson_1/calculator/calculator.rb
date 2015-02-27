# calculator.rb

# determine if selected operation is valid
def valid_operation(choice)
  (1..4).each do |i|
    return true if choice.to_i == i
  end
  false
end

# determine if input is a valid number
def is_number?(num)
  chars = num.split('')
  chars.delete('.')
  result = true
  chars.each { |char| result = false if !char.between?('0', '9') }
  result
end

begin
  puts "Please enter the first number:"
  num1 = gets.chomp
end while is_number?(num1) == false

begin
  puts "Please enter the second number:"
  num2 = gets.chomp
end while is_number?(num2) == false

begin
  puts "1) Add 2) Subtract 3) Multiply 4) Divide"
  operation = gets.chomp
  # protect against division by zero
  if (operation == '4') && (num2 == '0')
    puts "Cannot divide by zero. Please make another selection."
    operation = '0'
  end
end while valid_operation(operation) == false

# perform calculation
case operation
when '1'
  result = num1.to_i + num2.to_i
when '2'
  result = num1.to_i - num2.to_i
when '3'
  result = num1.to_i * num2.to_i
else
  result = num1.to_f / num2.to_f
end

puts "Result: #{result}"