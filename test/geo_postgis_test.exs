defmodule Geo.PostGIS.Test do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Postgrex.start_link(Geo.Test.Helper.opts())

    {:ok, _result} =
      Postgrex.query(
        pid,
        "DROP TABLE IF EXISTS text_test, point_test, linestring_test, polygon_test, multipoint_test, multilinestring_test, multipolygon_test, geometrycollection_test",
        []
      )

    {:ok, [pid: pid]}
  end

  test "insert point", context do
    pid = context[:pid]
    geo = %Geo.Point{coordinates: {30, -90}, srid: 4326}

    {:ok, _} =
      Postgrex.query(pid, "CREATE TABLE point_test (id int, geom geometry(Point, 4326))", [])

    {:ok, _} = Postgrex.query(pid, "INSERT INTO point_test VALUES ($1, $2)", [42, geo])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM point_test", [])
    assert(result.rows == [[42, geo]])
  end

  test "insert with text column", context do
    pid = context[:pid]
    geo = %Geo.Point{coordinates: {30, -90}, srid: 4326}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE text_test (id int, t text, geom geometry(Point, 4326))",
        []
      )

    {:ok, _} =
      Postgrex.query(pid, "INSERT INTO text_test (id, t, geom) VALUES ($1, $2, $3)", [
        42,
        "test",
        geo
      ])

    {:ok, result} = Postgrex.query(pid, "SELECT id, t, geom FROM text_test", [])
    assert(result.rows == [[42, "test", geo]])
  end

  test "insert pointz", context do
    pid = context[:pid]
    geo = %Geo.PointZ{coordinates: {30, -90, 70}, srid: 4326}

    {:ok, _} =
      Postgrex.query(pid, "CREATE TABLE point_test (id int, geom geometry(PointZ, 4326))", [])

    {:ok, _} = Postgrex.query(pid, "INSERT INTO point_test VALUES ($1, $2)", [42, geo])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM point_test", [])
    assert(result.rows == [[42, geo]])
  end

  test "insert linestring", context do
    pid = context[:pid]
    geo = %Geo.LineString{srid: 4326, coordinates: [{30, 10}, {10, 30}, {40, 40}]}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE linestring_test (id int, geom geometry(Linestring, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO linestring_test VALUES ($1, $2)", [42, geo])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM linestring_test", [])
    assert(result.rows == [[42, geo]])
  end

  test "insert polygon", context do
    pid = context[:pid]

    geo = %Geo.Polygon{
      coordinates: [
        [{35, 10}, {45, 45}, {15, 40}, {10, 20}, {35, 10}],
        [{20, 30}, {35, 35}, {30, 20}, {20, 30}]
      ],
      srid: 4326
    }

    {:ok, _} =
      Postgrex.query(pid, "CREATE TABLE polygon_test (id int, geom geometry(Polygon, 4326))", [])

    {:ok, _} = Postgrex.query(pid, "INSERT INTO polygon_test VALUES ($1, $2)", [42, geo])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM polygon_test", [])
    assert(result.rows == [[42, geo]])
  end

  test "insert mulitpoint", context do
    pid = context[:pid]
    geo = %Geo.MultiPoint{coordinates: [{0, 0}, {20, 20}, {60, 60}], srid: 4326}

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE multipoint_test (id int, geom geometry(MultiPoint, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO multipoint_test VALUES ($1, $2)", [42, geo])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM multipoint_test", [])
    assert(result.rows == [[42, geo]])
  end

  test "insert mulitlinestring", context do
    pid = context[:pid]

    geo = %Geo.MultiLineString{
      coordinates: [[{10, 10}, {20, 20}, {10, 40}], [{40, 40}, {30, 30}, {40, 20}, {30, 10}]],
      srid: 4326
    }

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE multilinestring_test (id int, geom geometry(MultiLinestring, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO multilinestring_test VALUES ($1, $2)", [42, geo])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM multilinestring_test", [])
    assert(result.rows == [[42, geo]])
  end

  test "insert mulitpolygon", context do
    pid = context[:pid]

    geo = %Geo.MultiPolygon{
      coordinates: [
        [[{40, 40}, {20, 45}, {45, 30}, {40, 40}]],
        [
          [{20, 35}, {10, 30}, {10, 10}, {30, 5}, {45, 20}, {20, 35}],
          [{30, 20}, {20, 15}, {20, 25}, {30, 20}]
        ]
      ],
      srid: 4326
    }

    {:ok, _} =
      Postgrex.query(
        pid,
        "CREATE TABLE multipolygon_test (id int, geom geometry(MultiPolygon, 4326))",
        []
      )

    {:ok, _} = Postgrex.query(pid, "INSERT INTO multipolygon_test VALUES ($1, $2)", [42, geo])
    {:ok, result} = Postgrex.query(pid, "SELECT * FROM multipolygon_test", [])
    assert(result.rows == [[42, geo]])
  end
end
