using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CentrographyAnalysis.Helpers
{
    public class MatrixHelper
    {
        // Return the matrix's inverse or null if it has none.
        private static double[,] InvertMatrix(double[,] matrix)
        {
            const double tiny = 0.00001;

            // Build the augmented matrix.
            int num_rows = matrix.GetUpperBound(0) + 1;
            double[,] augmented = new double[num_rows, 2 * num_rows];
            for (int row = 0; row < num_rows; row++)
            {
                for (int col = 0; col < num_rows; col++)
                    augmented[row, col] = matrix[row, col];
                augmented[row, row + num_rows] = 1;
            }

            // num_cols is the number of the augmented matrix.
            int num_cols = 2 * num_rows;

            // Solve.
            for (int row = 0; row < num_rows; row++)
            {
                // Zero out all entries in column r after this row.
                // See if this row has a non-zero entry in column r.
                if (Math.Abs(augmented[row, row]) < tiny)
                {
                    // Too close to zero. Try to swap with a later row.
                    for (int r2 = row + 1; r2 < num_rows; r2++)
                    {
                        if (Math.Abs(augmented[r2, row]) > tiny)
                        {
                            // This row will work. Swap them.
                            for (int c = 0; c < num_cols; c++)
                            {
                                double tmp = augmented[row, c];
                                augmented[row, c] = augmented[r2, c];
                                augmented[r2, c] = tmp;
                            }
                            break;
                        }
                    }
                }

                // If this row has a non-zero entry in column r, use it.
                if (Math.Abs(augmented[row, row]) > tiny)
                {
                    // Divide the row by augmented[row, row] to make this entry 1.
                    for (int col = 0; col < num_cols; col++)
                        if (col != row)
                            augmented[row, col] /= augmented[row, row];
                    augmented[row, row] = 1;

                    // Subtract this row from the other rows.
                    for (int row2 = 0; row2 < num_rows; row2++)
                    {
                        if (row2 != row)
                        {
                            double factor = augmented[row2, row] / augmented[row, row];
                            for (int col = 0; col < num_cols; col++)
                                augmented[row2, col] -= factor * augmented[row, col];
                        }
                    }
                }
            }

            // See if we have a solution.
            if (augmented[num_rows - 1, num_rows - 1] == 0) return null;

            // Extract the inverse array.
            double[,] inverse = new double[num_rows, num_rows];
            for (int row = 0; row < num_rows; row++)
            {
                for (int col = 0; col < num_rows; col++)
                {
                    inverse[row, col] = augmented[row, col + num_rows];
                }
            }

            return inverse;
        }

        private static double[,] Multiply(double[,] matrixA, double[,] matrixB)
        {
            int row = matrixA.GetUpperBound(0) + 1;
            int col = matrixB.Length / (matrixB.GetUpperBound(0) + 1);
            int arrayMax = matrixB.Length / col;

            double[,] result = new double[row, col];
            for (int i = 0; i < row; i++)
            {
                for (int j = 0; j < col; j++)
                {
                    result[i, j] = 0;
                    for (int k = 0; k < arrayMax; k++)
                    {
                        result[i, j] += matrixA[i, k] * matrixB[k, j];
                    }
                }
            }

            return result;
        }

        private static double[,] GetMahalanobisMatrix(double[,] mainMatrix)
        {
            int rowMain = mainMatrix.GetUpperBound(0) + 1;
            int colMain = mainMatrix.Length / rowMain;

            int[] meanArray = new int[colMain];

            double sumX = 0;
            double sumY = 0;

            for (int i = 0; i < rowMain; i++)
            {
                sumX += mainMatrix[i, 0];
                sumY += mainMatrix[i, 1];
            }

            double avgX = sumX / (1.0 * rowMain);
            double avgY = sumY / (1.0 * rowMain);

            double[,] covArray = new double[rowMain, colMain];
            for (int i = 0; i < rowMain; i++)
            {
                covArray[i, 0] = mainMatrix[i, 0] - avgX;
                covArray[i, 1] = mainMatrix[i, 1] - avgY;
            }

            double[,] covTranspose = GetTranspose(covArray);



            double[,] covarianceMatrix = Multiply(covTranspose, covArray);

            for (int i = 0; i < colMain; i++)
            {
                for (int j = 0; j < colMain; j++)
                {
                    covarianceMatrix[i, j] = covarianceMatrix[i, j] / (1.0 * rowMain);
                }
            }

            double[,] invCovariance = InvertMatrix(covarianceMatrix);

            double[,] distCov = Multiply(covArray, invCovariance);
            double[,] result = Multiply(distCov, covTranspose);

            for (int i = 0; i < rowMain; i++)
            {
                for (int j = 0; j < rowMain; j++)
                {
                    result[i, j] = Math.Sqrt(result[i, j]);
                }
            }

            return result;
        }

        private static double[,] GetTranspose(double[,] mainMatrix)
        {
            int rowMain = mainMatrix.GetUpperBound(0) + 1;
            int colMain = mainMatrix.Length / rowMain;

            double[,] result = new double[colMain, rowMain];

            for (int i = 0; i < rowMain; i++)
            {
                for (int j = 0; j < colMain; j++)
                {
                    result[j, i] = mainMatrix[i, j];
                }
            }

            return result;
        }
    }
}