(ns armstrong-numbers
  (:require [clojure.string :as string]
            [clojure.math.numeric-tower :as math]))

(defn sum_digits_exponentiated_by_count [str_number, digits_count]
  (reduce
   (fn [acc, x] (-> x
                    (Integer/parseInt)
                    (math/expt digits_count)
                    (+ acc)))
   0
   (string/split str_number #"")))

(defn armstrong? [num]
  (let [str_number (str num)
        number_of_digits (count str_number)
        expt_digits_summed (sum_digits_exponentiated_by_count str_number number_of_digits)]
    (= num expt_digits_summed)))
