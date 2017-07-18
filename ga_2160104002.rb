# 2160104002 安達健二

# 所要時間、仲良くなれる度、リラックス度、健康的度、先生からの好感度、集中力が高まる度、満足度
matrix = [[60, 0, 0, 1, 5, 0, -2], [20, 0, 3, 1, 3, 2, 0], [120, 2, 4, 3, 1, 1, 3], [30, 4, 2, 5, 3, 2, 4],
[60, 2, 2, 3, 1, 1, 3], [60, 2, 3, 3, 1, 1, 3], [20, 3, 2, 3, 1, 2, 2], [10, 1, 0, 5, 3, 4, -2],
[60, 5, 3, 1, 2, 1, 4], [60, 3, 2, 1, 2, 1, 2], [40, 2, 3, 3, 1, 1, 1], [40, 2, 3, 3, 1, 1, 1],
[30, 0, 5, 4, 0, 4, 3], [30, -2, 4, 4, 4, 2, 3], [20, 1, 5, 5, 3, 4, 2], [10, 5, 5, -2, 0, 5, 4],
[180, 5, 3, 3, 3, -2, 5]]

# ナップザックに入る容量
MAX_TIME = 300

# 個体数
X = 10

# 世代数
GEN = 100

# ランダムに初期個体生成
first_list = Array.new(X){Array.new(17, 0)}
first_list.each do |ind|
  ind.map! {|item| item = Random.rand(0..1)}
end

# 初期個体をcurrentに移す
$current_list = Marshal.load(Marshal.dump(first_list))

# GEN回繰り返し
GEN.times do |i|

  # 個体ごとの総容量、総価値
  $time_sum = Array.new(X, 0)
  $relat_sum = Array.new(X, 0)
  $relax_sum = Array.new(X, 0)
  $heal_sum = Array.new(X, 0)
  $fav_sum = Array.new(X, 0)
  $con_sum = Array.new(X, 0)
  $sat_sum = Array.new(X, 0)

  # 1のやつを足し合わせる
  $current_list.each_with_index do |ind, index|
    ind.each_with_index do |val, i|
      if val == 1 then
        $time_sum[index] = $time_sum[index] + matrix[i][0]
        $relat_sum[index] = $relat_sum[index] + matrix[i][1]
        $relax_sum[index] = $relax_sum[index] + matrix[i][2]
        $heal_sum[index] = $heal_sum[index] + matrix[i][3]
        $fav_sum[index] = $fav_sum[index] + matrix[i][4]
        $con_sum[index] = $con_sum[index] + matrix[i][5]
        $sat_sum[index] = $sat_sum[index] + matrix[i][6]
      end
    end
  end

  # valueを掛け算で求める
  $val_sum = Array.new(X, 1)
  $val_sum.map!.with_index { |data, index| data = $relat_sum[index] * $relax_sum[index] * $heal_sum[index] * $fav_sum[index] * $con_sum[index] * $sat_sum[index] }
  # $val_sum.map!.with_index { |data, index| data = $relat_sum[index] + $relax_sum[index] + $heal_sum[index] + $fav_sum[index] + $con_sum[index] + $sat_sum[index] }

  # ナップザックに入りきってないやつのvalueを0に
  $time_sum.each_with_index do |ind, index|
    if ind > MAX_TIME then
      $val_sum[index] = 0
    end
  end

  if i < GEN-1 then
    # n=2のトーナメント戦略でX個の個体を選択(重複あり)
    next_list = Array.new(X)
    next_list.each_with_index do |ind, index|
      tmp1 = Random.rand(X)
      tmp2 = Random.rand(X)
      part1 = $val_sum[tmp1]
      part2 = $val_sum[tmp2]
      if part1 > part2 then
        next_list[index] = $current_list[tmp1].clone
      else
        next_list[index] = $current_list[tmp2].clone
      end
    end

    # ランダムな3組を中央で分割し、交叉させる
    next_list = next_list.shuffle
    # 要素を取り出す
    tmp1 = next_list[0].slice(9, 8)
    tmp2 = next_list[1].slice(9, 8)
    tmp3 = next_list[2].slice(9, 8)
    tmp4 = next_list[3].slice(9, 8)
    tmp5 = next_list[4].slice(9, 8)
    tmp6 = next_list[5].slice(9, 8)
    # 取り出した部分の削除
    next_list[0].slice!(9, 8)
    next_list[1].slice!(9, 8)
    next_list[2].slice!(9, 8)
    next_list[3].slice!(9, 8)
    next_list[4].slice!(9, 8)
    next_list[5].slice!(9, 8)
    # tmpを結合
    next_list[0] = next_list[0].concat(tmp2)
    next_list[1] = next_list[1].concat(tmp1)
    next_list[2] = next_list[2].concat(tmp4)
    next_list[3] = next_list[3].concat(tmp3)
    next_list[4] = next_list[4].concat(tmp6)
    next_list[5] = next_list[5].concat(tmp5)

    # 10%の確率で1個体の1要素が1になる突然変異を発生させる
    if Random.rand(0..9) == 7
      next_list = next_list.shuffle
      next_list[0][Random.rand(0..16)] = 1
    end

    # next_listをcurrent_listに
    $current_list = Marshal.load(Marshal.dump(next_list))
  end
end

# エリートのやつを持ってくる
$elite = 1
$elite_num = 99
$val_sum.each_with_index do |value, i|
  if $elite < value then
    $elite = value
    $elite_num = i
  end
end

# エリートの詳細を教えて！
p $elite
p $elite_num
p $current_list[$elite_num]
