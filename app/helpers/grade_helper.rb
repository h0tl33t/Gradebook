module GradeHelper #Be sure to include :grade in the application control helper listing => helper :grade
  class << self
    def grade_table(value = nil)
      grade_table = {4.0 => 'A',
                     3.7 => 'A-',
                     3.3 => 'B+',
                     3.0 => 'B',
                     2.7 => 'B-',
                     2.3 => 'C+',
                     2.0 => 'C',
                     1.7 => 'C-',
                     1.3 => 'D+',
                     1.0 => 'D',
                     0.7 => 'D-',
                     0.3 => 'F',
                     0.0 => 'F'} #0.3 value enables the nearest_letter_grade calcluation to work solely based on the decimal values .0, .3, and .7.
      value ? grade_table[value] : grade_table
    end
    
    def numeric_grade_for(letter_grade)
      numeric_grades = {'A'   => 4.0,
                        'A-'  => 3.7,
                        'B+'  => 3.3,
                        'B'   => 3.0,
                        'B-'  => 2.7,
                        'C+'  => 2.3,
                        'C'   => 2.0,
                        'C-'  => 1.7,
                        'D+'  => 1.3,
                        'D'   => 1.0,
                        'D-'  => 0.7,
                        'F'   => 0.0}
      numeric_grades[letter_grade]
    end

    def letter_grades
      grade_table.values.uniq #Must be unique so 'F' doesn't occur twice, since both 0.3 and 0.0 are assigned an F letter grade.
    end

    def letter_grade_for(value)
      grade_table(value.round(1)) || nearest_letter_grade(value.round(1)) #Looks to see if it matches a grade in the grade table, and looks for the nearest grade if not.
    end

    def valid?(value) #Checks to see if the grade is within the valid set of ranges (either by float or string)
      if value.class == Float
        (0.0..4.0).include?(value)
      elsif value.class == String
        letter_grades.include?(value)
      else
        false
      end
    end

    def nearest_letter_grade(value) #Nearest ascendor value in array given value.
      grade_table(nearest_decimal_grade(value))
    end

    def nearest_decimal_grade(value) #Expects a valid grade in type-float that does not match any values in grade_table.
      decimal = value.modulo(1).round(1) #Decimal portion of grade value.
      if decimal == 0.1
        value.truncate + 0.0 #Convert n.1 to n.0
      elsif [0.2, 0.4, 0.5].include?(decimal)
        value.truncate + 0.3 #Covert n.2, n.4, or n.5 to n.3
      elsif [0.6, 0.8].include?(decimal)
        value.truncate + 0.7 #Convert n.6 or n.8 to n.7
      else #0.9
        value.truncate + 1.0 #Convert n.9 to n+1.0
      end
    end
  end
end