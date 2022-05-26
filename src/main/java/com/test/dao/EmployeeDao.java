package com.test.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import com.test.domain.Employee;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface EmployeeDao {
	
	List<Employee> list(Map<String,Object> map);
	
	int count(Map<String,Object> map);
	
	int save(Employee employee);
	
	int update(Employee employee);
	
	int remove(Integer id);
	
	int batchRemove(@Param("ids") Integer[] ids);
}
