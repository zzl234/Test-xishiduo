package com.test.domain;

import java.io.Serializable;

public class Employee implements Serializable {

	private static final long serialVersionUID = -394580405407547372L;

	private Integer id;// 编号
	private String name;// 姓名

	private String birthDay;// 出生年月 yyyy-MM-dd
	private String sex;// 性别 1男 2女
	private String departName;// 所属部门名称

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBirthDay() {
		return birthDay;
	}

	public void setBirthDay(String birthDay) {
		this.birthDay = birthDay;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getDepartName() {
		return departName;
	}

	public void setDepartName(String departName) {
		this.departName = departName;
	}

	@Override
	public String toString() {
		return "Employee [id=" + id + ", name=" + name + ", birthDay=" + birthDay + ", sex=" + sex + ", departName="
				+ departName + "]";
	}


}
