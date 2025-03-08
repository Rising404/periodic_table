#! /bin/bash

# 设置 PSQL 变量
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# 如果没有提供参数
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# 获取输入参数
INPUT=$1

# 查询元素信息
QUERY_RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                      FROM elements e
                      JOIN properties p ON e.atomic_number = p.atomic_number
                      JOIN types t ON p.type_id = t.type_id
                      WHERE e.atomic_number::TEXT = '$INPUT' OR e.symbol = '$INPUT' OR e.name = '$INPUT'")

# 如果未找到元素
if [[ -z $QUERY_RESULT ]]; then
  echo "I could not find that element in the database."
  exit
fi

# 解析查询结果
IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$QUERY_RESULT"

# 输出元素信息
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
