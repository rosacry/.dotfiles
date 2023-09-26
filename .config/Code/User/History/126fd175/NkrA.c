#include <stdlib.h>

#include "debug.h"
#include "global.h"

/**
 * @brief  Read genetic distance data and initialize data structures.
 * @details  This function reads genetic distance data from a specified
 * input stream, parses and validates it, and initializes internal data
 * structures.
 *
 * The input format is a simplified version of Comma Separated Values
 * (CSV).  Each line consists of text characters, terminated by a newline.
 * Lines that start with '#' are considered comments and are ignored.
 * Each non-comment line consists of a nonempty sequence of data fields;
 * each field iis terminated either by ',' or else newline for the last
 * field on a line.  The constant INPUT_MAX specifies the maximum number
 * of data characters that may be in an input field; fields with more than
 * that many characters are regarded as invalid input and cause an error
 * return.  The first field of the first data line is empty;
 * the subsequent fields on that line specify names of "taxa", which comprise
 * the leaf nodes of a phylogenetic tree.  The total number N of taxa is
 * equal to the number of fields on the first data line, minus one (for the
 * blank first field).  Following the first data line are N additional lines.
 * Each of these lines has N+1 fields.  The first field is a taxon name,
 * which must match the name in the corresponding column of the first line.
 * The subsequent fields are numeric fields that specify N "distances"
 * between this taxon and the others.  Any additional lines of input following
 * the last data line are ignored.  The distance data must form a symmetric
 * matrix (i.e. D[i][j] == D[j][i]) with zeroes on the main diagonal
 * (i.e. D[i][i] == 0).
 *
 * If 0 is returned, indicating data successfully read, then upon return
 * the following global variables and data structures have been set:
 *   num_taxa - set to the number N of taxa, determined from the first data line
 *   num_all_nodes - initialized to be equal to num_taxa
 *   num_active_nodes - initialized to be equal to num_taxa
 *   node_names - the first N entries contain the N taxa names, as C strings
 *   distances - initialized to an NxN matrix of distance values, where each
 *     row of the matrix contains the distance data from one of the data lines
 *   nodes - the "name" fields of the first N entries have been initialized
 *     with pointers to the corresponding taxa names stored in the node_names
 *     array.
 *   active_node_map - initialized to the identity mapping on [0..N);
 *     that is, active_node_map[i] == i for 0 <= i < N.
 *
 * @param in  The input stream from which to read the data.
 * @return 0 in case the data was successfully read, otherwise -1
 * if there was any error.  Premature termination of the input data,
 * failure of each line to have the same number of fields, and distance
 * fields that are not in numeric format should cause a one-line error
 * message to be printed to stderr and -1 to be returned.
 */

int read_distance_data(FILE *in) {
    int entries = 0;
    int rows = 0;  // # of lines
    int totalrows = 0;
    int remname = 0;
    int cname = 0;
    char c;  // iterator
    while ((c = fgetc(in)) == '#') {
        while ((c = fgetc(in)) != '\n' && c != EOF) {
        }
    }                                              // find the last comment ('#') in the csv file, then start parsing
    ungetc(c, in);                                 // go back one character to start from at the beginning
    while ((c = fgetc(in)) != '\n' && c != EOF) {  // find # of taxa
        if (c == ',') {
            rows++;
        }
    }
    totalrows = rows;
    if (rows > MAX_TAXA || rows <= 1) {
        fprintf(stderr, "Invalid number of taxa!. There are %d taxa\n", rows);
        return -1;
    }
    num_taxa = num_all_nodes = num_active_nodes = rows;  // since all taxa start off as leaf nodes and all active nodes start as taxa
    while ((c = fgetc(in)) != EOF) {                     // begin parsing text
        if (!remname) {                                  // removing column name
                                                         // now we add the column name here
            cname = 0;
            while (c != ',') {
                *(input_buffer + cname++) = c;
                c = fgetc(in);
            }
            // *(input_buffer + cname) = '\0';
            nodes[totalrows - rows].name = node_names[totalrows - rows];  // do i need to do this?
            for (int i = 0; i < cname; i++) {
                // fprintf(stderr, "%c", *(input_buffer + i));
                *(*(node_names + (totalrows - rows)) + i) = *(input_buffer + i);
            }
            // fprintf(stderr, "\n");
            *(*(node_names + (totalrows - rows)) + cname) = '\0';
            remname = 1;
        } else {  // process letters (taxons) / distances
            int val_in = 0;
            if (entries == 0) {
                fprintf(stderr, "Row #%d\n", totalrows - rows + 1);
            }
            while (c != '\n' && c != ',') {  // since we passed the point to check for a letter, we check for if there's either a comma or a new line
                if (val_in < INPUT_MAX) {    // checking if we've surpassed the amount of nodes alloted
                    *(input_buffer + val_in++) = c;
                    c = fgetc(in);
                } else {
                    printf("Input exceeds INPUT_MAX!\n");
                    return -1;
                }
            }
            *(input_buffer + val_in) = '\0';  // null terminating character to end the character being parsed
            if (rows == 0) {                  // letters (taxons)
                if (val_in == 0) {
                    printf("No taxon name!\n");
                    return -1;
                }
            } else {                // reading distance
                if (val_in == 0) {  // checking if there is a distance read
                    printf("No distance value!\n");
                    return -1;
                }
                double distance = 0;
                int decimal = 0;
                int place = 10;
                for (int i = 0; i < val_in; i++) {  // converting distance character to number
                    if (*(input_buffer + i) >= '0' && *(input_buffer + i) <= '9') {
                        if (decimal) {
                            distance = (distance + (*(input_buffer + i) - '0') / (double)place);
                            place *= 10;
                        } else {
                            distance = distance * 10 + (*(input_buffer + i) - '0');
                        }
                    } else if (*(input_buffer + i) == '.' && !decimal) {  // when there's a decimal
                        decimal = 1;
                        if (*(input_buffer + i + 1) == '\0') {
                            printf("There's no digit following the decimal!\n");
                        }
                        place = 10;
                    } else if (*(input_buffer + i) == '.' && decimal) {  // if it catches another decimal after one that's already been parsed
                        printf("Multiple decimals in argument!\n");
                        return -1;
                    } else {
                        fprintf(stderr, "Input buffer %c\n", *(input_buffer + i));
                        printf("Non-numeric character has been passed in the distance data!\n");
                        return -1;
                    }
                    // storing the extracted distance value
                }
                *(*(distances + rows - 1) + val_in - 2) = distance;  // rows - 1 since 0 based and val_in - 2 since the first field is empty and last is what we are trying to get
                fprintf(stderr, "entry: %d distance: %f\n", entries + 1, distance);
                entries++;
                if (entries == totalrows) {
                    rows--;
                    entries = 0;
                    remname = 0;
                }
            }
        }
    }
    for (int i = 0; i < totalrows; i++) {
        fprintf(stderr, "Column Name: %s\n", nodes[i].name);
    }
    // starting to initialize active_node_map
    for (int i = 0; i < num_taxa; i++) {
        *(active_node_map + i) = i;
    }
    return 0;
    // abort();
}
/**
 * @brief  Emit a representation of the phylogenetic tree in Newick
 * format to a specified output stream.
 * @details  This function emits a representation in Newick format
 * of a synthesized phylogenetic tree to a specified output stream.
 * See (https://en.wikipedia.org/wiki/Newick_format) for a description
 * of Newick format.  The tree that is output will include for each
 * node the name of that node and the edge distance from that node
 * its parent.  Note that Newick format basically is only applicable
 * to rooted trees, whereas the trees constructed by the neighbor
 * joining method are unrooted.  In order to turn an unrooted tree
 * into a rooted one, a root will be identified according by the
 * following method: one of the original leaf nodes will be designated
 * as the "outlier" and the unique node adjacent to the outlier
 * will serve as the root of the tree.  Then for any other two nodes
 * adjacent in the tree, the node closer to the root will be regarded
 * as the "parent" and the node farther from the root as a "child".
 * The outlier node itself will not be included as part of the rooted
 * tree that is output.  The node to be used as the outlier will be
 * determined as follows:  If the global variable "outlier_name" is
 * non-NULL, then the leaf node having that name will be used as
 * the outlier.  If the value of "outlier_name" is NULL, then the
 * leaf node having the greatest total distance to the other leaves
 * will be used as the outlier.
 *
 * @param out  Stream to which to output a rooted tree represented in
 * Newick format.
 * @return 0 in case the output is successfully emitted, otherwise -1
 * if any error occurred.  If the global variable "outlier_name" is
 * non-NULL, then it is an error if no leaf node with that name exists
 * in the tree.
 */
int emit_newick_format(FILE *out) {
    // TO BE IMPLEMENTED
    abort();
}

/**
 * @brief  Emit the synthesized distance matrix as CSV.
 * @details  This function emits to a specified output stream a representation
 * of the synthesized distance matrix resulting from the neighbor joining
 * algorithm.  The output is in the same CSV form as the program input.
 * The number of rows and columns of the matrix is equal to the value
 * of num_all_nodes at the end of execution of the algorithm.
 * The submatrix that consists of the first num_leaves rows and columns
 * is identical to the matrix given as input.  The remaining rows and columns
 * contain estimated distances to internal nodes that were synthesized during
 * the execution of the algorithm.
 *
 * @param out  Stream to which to output a CSV representation of the
 * synthesized distance matrix.
 * @return 0 in case the output is successfully emitted, otherwise -1
 * if any error occurred.
 */
int emit_distance_matrix(FILE *out) {
    // To be implemented
    abort();
}

/**
 * @brief  Build a phylogenetic tree using the distance data read by
 * a prior successful invocation of read_distance_data().
 * @details  This function assumes that global variables and data
 * structures have been initialized by a prior successful call to
 * read_distance_data(), in accordance with the specification for
 * that function.  The "neighbor joining" method is used to reconstruct
 * phylogenetic tree from the distance data.  The resulting tree is
 * an unrooted binary tree having the N taxa from the original input
 * as its leaf nodes, and if (N > 2) having in addition N-2 synthesized
 * internal nodes, each of which is adjacent to exactly three other
 * nodes (leaf or internal) in the tree.  As each internal node is
 * synthesized, information about the edges connecting it to other
 * nodes is output.  Each line of output describes one edge and
 * consists of three comma-separated fields.  The first two fields
 * give the names of the nodes that are connected by the edge.
 * The third field gives the distance that has been estimated for
 * this edge by the neighbor-joining method.  After N-2 internal
 * nodes have been synthesized and 2*(N-2) corresponding edges have
 * been output, one final edge is output that connects the two
 * internal nodes that still have only two neighbors at the end of
 * the algorithm.  In the degenerate case of N=1 leaf, the tree
 * consists of a single leaf node and no edges are output.  In the
 * case of N=2 leaves, then no internal nodes are synthesized and
 * just one edge is output that connects the two leaves.
 *
 * Besides emitting edge data (unless it has been suppressed),
 * as the tree is built a representation of it is constructed using
 * the NODE structures in the nodes array.  By the time this function
 * returns, the "neighbors" array for each node will have been
 * initialized with pointers to the NODE structure(s) for each of
 * its adjacent nodes.  Entries with indices less than N correspond
 * to leaf nodes and for these only the neighbors[0] entry will be
 * non-NULL.  Entries with indices greater than or equal to N
 * correspond to internal nodes and each of these will have non-NULL
 * pointers in all three entries of its neighbors array.
 * In addition, the "name" field each NODE structure will contain a
 * pointer to the name of that node (which is stored in the corresponding
 * entry of the node_names array).
 *
 * @param out  If non-NULL, an output stream to which to emit the edge data.
 * If NULL, then no edge data is output.
 * @return 0 in case the output is successfully emitted, otherwise -1
 * if any error occurred.
 */
int build_taxonomy(FILE *out) {
    // TO BE IMPLEMENTED
    abort();
}
