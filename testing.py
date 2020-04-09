import pandas as pd


from matplotlib import pyplot as plt


x = [1,2,3]
y = [1,4,9]
z = [10,5,0]
plt.plot(x,y)
plt.plot(x,z)
plt.title("Test Plot")
plt.xlabel("x")
plt.ylabel("y and z")
plt.legend(["This is y", "This is z"])
plt.show()

sample_data = pd.read_csv("sample_data.csv")
type(sample_data)
type(sample_data.column_c)
sample_data.column_c.iloc[3]

plt.plot(sample_data.column_a, sample_data.column_b)
plt.plot(sample_data.column_a, sample_data.column_c)

plt.show()

data = pd.read_csv("countries.csv")

# compare population growth for US and China

us = data[data.country == "United States"]
china = data[data.country == "China"]

plt.plot(us.year, us.population / 10**6)
plt.plot(china.year, china.population / 10**6)
plt.legend(["US Population", "Chinese Population"])
plt.xlabel("year")
plt.ylabel("Population in Mio.")
plt.show()

# making percentage changes:



plt.plot(us.year, (us.population / us.population.iloc[0] * 100)-100)
plt.plot(china.year, (china.population / china.population.iloc[0] * 100)-100)
plt.legend(["US Population", "Chinese Population"])
plt.xlabel("year")
plt.ylabel("Population Growth")
plt.show()

# test 
###
