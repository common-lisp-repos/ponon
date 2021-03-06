;;; -*- Mode: Lisp; indent-tabs-mode: nil -*-
;;;
;;; shapes.lisp --- Ponon 2d shapes
;;;
;;; Copyright (c) 2011, Boian Tzonev <boiantz@gmail.com>
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a copy
;;; of this software and associated documentation files (the "Software"), to deal
;;; in the Software without restriction, including without limitation the rights
;;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;;; copies of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included in
;;; all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;;; THE SOFTWARE.

(in-package :ponon)

(defmacro with-state (&body body)
  `(progn 
     (gl:with-pushed-matrix
       ,@body)))

(defclass shape ()
  ((color :accessor color :initarg :color)
   (line-width :accessor line-width :initarg :line-width :initform 1)))

(defgeneric draw-shape (shape))

(defmethod draw-shape :around ((obj shape))
  (gl:with-pushed-attrib (:current-bit :line-bit)
    (when (vectorp (color obj))
      (gl:line-width (line-width obj))
      (gl:color (aref (color obj) 0) (aref (color obj) 1) (aref (color obj) 2))
      (call-next-method))))

;;line
(defclass line (shape)
  ((x1 :accessor x1 :initarg :x1)
   (y1 :accessor y1 :initarg :y1)
   (x2 :accessor x2 :initarg :x2)
   (y2 :accessor y2 :initarg :y2)))

(defmethod draw-shape ((obj line))
  (draw-line (x1 obj) (y1 obj) (x2 obj) (y2 obj)))

(defun make-line (x1 y1 x2 y2)
  (make-instance 'line :x1 x1 :y1 y1 :x2 x2 :y2 y2))

;;rectangle
(defclass rectangle (shape)
  ((x :accessor rect-x :initform 0 :initarg :x)
   (y :accessor rect-y :initform 0 :initarg :y)
   (width :accessor rect-width :initform 0 :initarg :width)
   (height :accessor rect-height :initform 0 :initarg :height)))

(defmethod draw-shape ((rect rectangle))
  (draw-rectangle (rect-x rect) (rect-y rect) (rect-width rect) (rect-height rect)))

(defun make-rectangle (x y width height color)
  (make-instance 'rectangle :x x :y y :width width :height height :color color))

;;triangle
(defclass triangle (shape)
  ((x1 :accessor x1 :initarg :x1)
   (y1 :accessor y1 :initarg :y1)
   (x2 :accessor x2 :initarg :x2)
   (y2 :accessor y2 :initarg :y2)
   (x3 :accessor x3 :initarg :x3)
   (y3 :accessor y3 :initarg :y3)))

(defmethod draw-shape ((obj triangle))
  (draw-triangle (x1 obj) (y1 obj) (x2 obj) (y2 obj) (x3 obj) (y3 obj)))

(defun make-triangle (x1 y1 x2 y2 x3 y3)
  (make-instance 'triangle :x1 x1 :y1 y1 :x2 x2 :y2 y2 :x3 x3 :y3 y3))

;;cricle
(defclass circle (shape)
  ((x :accessor x :initform 0 :initarg :x)
   (y :accessor y :initform 0 :initarg :y)
   (radius :accessor radius :initarg :radius)))

(defmethod draw-shape ((obj circle))
  (draw-circle (x obj) (y obj) (radius obj)))

(defun make-circle (x y radius)
  (make-instance 'circle :x x :y y :radius radius))

;;arc
(defclass arc (shape)
  ((x :accessor x :initform 0 :initarg :x)
   (y :accessor y :initform 0 :initarg :y)
   (radius :accessor radius :initarg :radius)
   (start-angle :accessor start-angle :initarg :start-angle)
   (end-angle :accessor end-angle :initarg :end-angle)))

(defmethod draw ((obj arc))
  (draw-arc (x obj) (y obj) (radius obj) (start-angle obj) (end-angle obj)))

(defun make-arc (x y radius start-angle end-angle)
  (make-instance 'arc :x x :y y :radius radius :start-angle start-angle :end-angle end-angle))

;;polygon
(defclass polygon (shape)
  ((points :accessor points :initarg points)))

(defmethod draw-shape ((obj polygon))
  (draw-polygon (points obj)))

(defun make-polygon (points)
  (make-instance 'polygon :points points))

;;curve
(defclass curve (shape)
  ((points :accessor points :initarg points)))

(defmethod draw-shape ((obj curve))
  (draw-curve (points obj)))

(defun make-curve (points)
  (make-instance 'curve :points points))