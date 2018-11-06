SELECT userType.id, userType.typ, tmp2.count FROM
	(SELECT COUNT(id) AS count, userType_id FROM (
		SELECT user.id, userType.id AS userType_id, userType.typ FROM user
		LEFT JOIN userType ON user.userType_id = userType.id
		UNION
		SELECT user.id, userType.id AS userType_id, userType.typ FROM user
		RIGHT JOIN userType ON user.userType_id = userType.id
		) AS tmp
	GROUP BY userType_id) AS tmp2
LEFT JOIN userType
ON userType.id = tmp2.userType_id;