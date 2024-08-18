#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/Surface_mesh.h>
#include <CGAL/Polygon_mesh_processing/remesh.h>
#include <CGAL/Polygon_mesh_processing/border.h>
#include <boost/function_output_iterator.hpp>
#include <fstream>
#include <vector>
#include <iostream>
#include <string>
#include <CGAL/Polyhedron_3.h>
#include <CGAL/Surface_mesh/IO/OFF.h>
#include <CGAL/Surface_mesh_approximation/approximate_triangle_mesh.h>
#include <CGAL/Polygon_mesh_processing/IO/polygon_mesh_io.h>
#include <CGAL/Scale_space_surface_reconstruction_3.h>
#include <CGAL/IO/Complex_2_in_triangulation_3_file_writer.h>
#include <CGAL/convex_hull_3.h>
#include <CGAL/Polygon_mesh_processing/repair.h>
#include <CGAL/boost/graph/iterator.h>
#include <CGAL/Polygon_mesh_processing/self_intersections.h>
#include <CGAL/Real_timer.h>
#include <CGAL/tags.h>
#include <CGAL/Simple_cartesian.h>
#include <CGAL/Surface_mesh_simplification/edge_collapse.h>
#include <CGAL/Surface_mesh_simplification/Policies/Edge_collapse/Count_ratio_stop_predicate.h>
#include <chrono>
#include <CGAL/property_map.h>
#include <CGAL/Variational_shape_approximation.h>
#include <CGAL/Polygon_mesh_processing/smooth_mesh.h>
#include <CGAL/Polygon_mesh_processing/detect_features.h>

typedef CGAL::Simple_cartesian<double>               Kernel;
typedef Kernel::Point_3                              Point_3;
typedef CGAL::Surface_mesh<Point_3>                  Surface_mesh;

namespace SMS = CGAL::Surface_mesh_simplification;

int main(int argc, char* argv[]) //Process one off file at a time, which can be adjusted to batch processing as needed
{

    Surface_mesh surface_mesh;
    const std::string filename = (argc > 1) ? argv[1] : CGAL::data_file_path("path/to/your/input/offfile");
    std::ifstream is(filename);
    if (!is || !(is >> surface_mesh))
    {
        std::cerr << "Failed to read input mesh: " << filename << std::endl;
        return EXIT_FAILURE;
    }

    if (!CGAL::is_triangle_mesh(surface_mesh))
    {
        std::cerr << "Input geometry is not triangulated." << std::endl;
        return EXIT_FAILURE;
    }

    std::chrono::steady_clock::time_point start_time = std::chrono::steady_clock::now();

    double stop_ratio = (argc > 2) ? std::stod(argv[2]) : 0.05;
    SMS::Count_ratio_stop_predicate<Surface_mesh> stop(stop_ratio);

    int r = SMS::edge_collapse(surface_mesh, stop);

    std::chrono::steady_clock::time_point end_time = std::chrono::steady_clock::now();

    std::cout << "\nFinished!\n" << r << " edges removed.\n" << surface_mesh.number_of_edges() << " final edges.\n";
    std::cout << "Time elapsed: " << std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count() << "ms" << std::endl;

    CGAL::IO::write_polygon_mesh((argc > 3) ? argv[3] : "path/to/your/output/offfile", surface_mesh, CGAL::parameters::stream_precision(17));

    return EXIT_SUCCESS;
}

