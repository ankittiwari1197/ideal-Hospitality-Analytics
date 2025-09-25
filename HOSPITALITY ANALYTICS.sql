SELECT 
    SUM(revenue_realized) AS 'Total Revenue'
FROM
    fact_bookings;

SELECT 
    CONCAT(ROUND(((SUM(capacity) - SUM(successful_bookings)) / SUM(capacity)) * 100,
                    2),
            '',
            '%') AS '% occupancy rate'
FROM
    fact_aggregated_bookings;

SELECT 
    CONCAT(ROUND((((SELECT 
                            COUNT(booking_status)
                        FROM
                            fact_bookings
                        WHERE
                            booking_status = 'Cancelled') / (SELECT 
                            COUNT(booking_id)
                        FROM
                            fact_bookings)) * 100),
                    2),
            '',
            '%') AS '% cancellation rate';

SELECT 
    SUM(successful_bookings) AS 'Total Bookings'
FROM
    fact_aggregated_bookings;

SELECT 
    CONCAT(ROUND((SUM(successful_bookings) / SUM(capacity)) * 100,
                    2),
            '',
            '%') AS 'Utilized rate'
FROM
    fact_aggregated_bookings;

SELECT 
    MONTHNAME(check_in_date), SUM(revenue_realized)
FROM
    fact_bookings
GROUP BY MONTHNAME(check_in_date);

SELECT 
    dd.day_type, SUM(fb.revenue_realized) AS 'Total revenue'
FROM
    dim_date dd
        JOIN
    fact_aggregated_bookings fab ON dd.date = fab.check_in_date
        JOIN
    (SELECT DISTINCT
        property_id, revenue_realized
    FROM
        fact_bookings) fb ON fab.property_id = fb.property_id
GROUP BY dd.day_type
LIMIT 1000;

SELECT 
    city, SUM(revenue_realized)
FROM
    dim_hotels dh
        JOIN
    fact_bookings fb ON dh.property_id = fb.property_id
GROUP BY city;

SELECT 
    room_class, SUM(revenue_realized)
FROM
    dim_rooms dr
        JOIN
    fact_aggregated_bookings fab ON dr.room_id = fab.room_category
        JOIN
    (SELECT DISTINCT
        property_id, revenue_realized
    FROM
        fact_bookings) fb ON fab.property_id = fb.property_id
GROUP BY room_class;

SELECT 
    booking_status, COUNT(ratings_given)
FROM
    fact_bookings
GROUP BY booking_status;

SELECT 	
    dd.week_no, SUM(fb.revenue_realized)
FROM
    dim_date dd
        JOIN
    fact_aggregated_bookings fab ON dd.date = fab.check_in_date
        JOIN
    (SELECT DISTINCT
        property_id, revenue_realized
    FROM
        fact_bookings) fb ON fab.property_id = fb.property_id
GROUP BY dd.week_no;



